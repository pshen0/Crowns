//
//  CrownsPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation
import UIKit

// MARK: - CrownsPlayBusinessLogic protocol
protocol CrownsPlayBusinessLogic {
    func backButtonTapped(_ request: CrownsPlayModel.RouteBack.Request)
    func pauseButtonTapped(_ request: CrownsPlayModel.PauseGame.Request)
    func hintButtonTapped(_ request: CrownsPlayModel.GetHint.Request)
    func undoButtonTapped(_ request: CrownsPlayModel.UndoMove.Request)
    
    func startTimer(_ request: CrownsPlayModel.StartTimer.Request)
    func getLevelPictute(_ request: CrownsPlayModel.GetLevel.Request)
    
    func getTable(_ request: CrownsPlayModel.GetTable.Request) -> [[CrownsCell]]
    func getPlacements(_ request: CrownsPlayModel.GetPlacements.Request) -> [[Int]]
    func isPlayFinished(_ request: CrownsPlayModel.CheckGameOver.Request) -> Bool
    func isPlayChallenge(_ request: CrownsPlayModel.CheckChallenge.Request) -> Bool
    func gameIsWon(_ request: CrownsPlayModel.GameIsWon.Request)
    func timeIsUp() -> Bool
    func placeCrown(_ request: CrownsPlayModel.PlaceCrown.Request)
    func leaveGame(_ request: CrownsPlayModel.LeaveGame.Request)
    func saveMove(_ request: CrownsPlayModel.SaveMove.Request)
}

// MARK: - CrownsPlayInteractor class
final class CrownsPlayInteractor: CrownsPlayBusinessLogic {
    
    // MARK: - Properties
    private let presenter: CrownsPlayPresentationLogic
    private let crowns: Crowns
    private var elapsedTime: Int
    private var initialTime: Int
    private var isTimerUsed: Bool
    private var placements: [[Int]]
    private var timer: Timer? = Timer()
    private var timeGoes: Bool = true
    private var savedMoves: [CrownsPlayModel.CrownsMove] = []
    
    // MARK: - Lifecycle
    init(presenter: CrownsPlayPresentationLogic, foundation: CrownsPlayModel.BuildModule.BuildFoundation) {
        self.presenter = presenter
        self.crowns = foundation.crowns
        self.elapsedTime = foundation.elapsedTime
        self.initialTime = foundation.initialTime
        self.isTimerUsed = foundation.isTimerUsed
        self.placements = foundation.placements
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Funcs
    func backButtonTapped(_ request: CrownsPlayModel.RouteBack.Request) {
        deinitTimer()
        presenter.roureBack(CrownsPlayModel.RouteBack.Response())
    }
    
    func pauseButtonTapped(_ request: CrownsPlayModel.PauseGame.Request) {
        if timeGoes {
            deinitTimer()
        } else {
            initTimer()
        }
    }
    
    func hintButtonTapped(_ request: CrownsPlayModel.GetHint.Request) {
        for i in 0..<Constants.size {
            for j in 0..<Constants.size {
                if crowns.table[i][j].hasCrown && placements[i][j] != CrownsCellContent.crown {
                    placements[i][j] = CrownsCellContent.crown
                    presenter.showHint(CrownsPlayModel.GetHint.Response(row: i, col: j, color: crowns.table[i][j].color.uiColor))
                    return
                }
            }
        }
    }
    
    func undoButtonTapped(_ request: CrownsPlayModel.UndoMove.Request) {
        if !savedMoves.isEmpty {
            if let indexPath = savedMoves.last?.indexPath, let crownsMove = savedMoves.last {
                placements[indexPath.item / Constants.size][indexPath.item % Constants.size] = crownsMove.value
                presenter.showUndoMove(CrownsPlayModel.UndoMove.Response(move: crownsMove, color: crowns.table[indexPath.item / Constants.size][indexPath.item % Constants.size].color.uiColor))
                savedMoves.remove(at: savedMoves.count - 1)
            }
        }
    }
    
    func startTimer(_ request: CrownsPlayModel.StartTimer.Request) {
        initTimer()
    }
    
    func getLevelPictute(_ request: CrownsPlayModel.GetLevel.Request) {
        var image: UIImage?
        switch crowns.difficultyLevel {
        case DifficultyLevels.hard:
            image = UIImage.hard
        case DifficultyLevels.medium:
            image = UIImage.medium
        default:
            image = UIImage.easy
        }
        
        presenter.setLevelImage(CrownsPlayModel.GetLevel.Response(image: image))
    }
    
    func getTable(_ request: CrownsPlayModel.GetTable.Request) -> [[CrownsCell]] {
        return crowns.puzzle
    }
    
    func getPlacements(_ request: CrownsPlayModel.GetPlacements.Request) -> [[Int]] {
        return self.placements
    }
    
    
    func isPlayFinished(_ request: CrownsPlayModel.CheckGameOver.Request) -> Bool {
        var counter = 0
        let table = crowns.table
        for i in 0..<Constants.size {
            for j in 0..<Constants.size {
                if table[i][j].hasCrown == true {
                    if placements[i][j] == CrownsCellContent.crown {
                        counter += 1
                    } else {
                        return false
                    }
                } else {
                    if placements[i][j] == CrownsCellContent.crown {
                        return false
                    }
                }
            }
        }
        if counter == Constants.size {
            return true
        }
        return false
    }
    
    func isPlayChallenge(_ request: CrownsPlayModel.CheckChallenge.Request) -> Bool {
        let isChallenge = UserDefaults.standard.bool(forKey: UserDefaultsKeys.crownsChallengeGoes)
        return isChallenge
    }
    
    func gameIsWon(_ request: CrownsPlayModel.GameIsWon.Request) {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.crownsChallengeGoes) {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.crownsChallengeDone)
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.sudokuChallengeDone) {
                CoreDataDatesStack.shared.saveDate(Date())
                print(CoreDataDatesStack.shared.fetchAllDates())
            }
        }
        
        playFinished(isWin: true)
        CoreDataCrownsStatisticStack.shared.recordWin(difficulty: crowns.difficultyLevel, time: Int32(elapsedTime))
    }
    
    func timeIsUp() -> Bool {
        return elapsedTime >= initialTime && isTimerUsed
    }
    
    func placeCrown(_ request: CrownsPlayModel.PlaceCrown.Request) {
        placements[request.row][request.col] = request.isPlaced
    }
    
    func leaveGame(_ request: CrownsPlayModel.LeaveGame.Request) {
        deinitTimer()
        CoreDataCrownsProgressStack.shared.saveProgress(isTimerUsed: self.isTimerUsed,
                                                        initialTime: Int32(self.initialTime),
                                                        elapsedTime: Int32(self.elapsedTime),
                                                        crowns: self.crowns,
                                                        placements: self.placements)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.unfinishedCrownsGame)
    }
    
    func saveMove(_ request: CrownsPlayModel.SaveMove.Request) {
        if savedMoves.count > Constants.undoNumbers {
            savedMoves.remove(at: 0)
        }
        savedMoves.append(request.move)
    }
    
    // MARK: - Private funcs
    private func playFinished(isWin: Bool) {
        deinitTimer()
        presenter.routeGameOver(CrownsPlayModel.RouteGameOver.Response(isWin: isWin, time: elapsedTime))
    }
    
    private func initTimer() {
        timeGoes = true
        if isTimerUsed {
            timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(reverseTimeChange), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(forwardTimeChange), userInfo: nil, repeats: true)
        }
    }
    
    private func deinitTimer() {
        timeGoes = false
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Actions
    @objc private func reverseTimeChange() {
        if initialTime - elapsedTime > 0 {
            elapsedTime += 1
            presenter.presentTime(CrownsPlayModel.SetTime.Response(time: initialTime - elapsedTime))
        } else {
            playFinished(isWin: false)
        }
    }
    
    @objc private func forwardTimeChange() {
        elapsedTime += 1
        presenter.presentTime(CrownsPlayModel.SetTime.Response(time: elapsedTime))
    }
    
    // MARK: - Constants
    private enum Constants {
        static let size = 9
        static let undoNumbers = 10
        static let timeInterval = 1.0
    }
}
