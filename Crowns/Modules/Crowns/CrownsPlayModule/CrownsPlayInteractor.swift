//
//  CrownsPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol CrownsPlayBusinessLogic {
    func backButtonTapped(_ request: CrownsPlayModel.RouteBack.Request)
    func getTable(_ request: CrownsPlayModel.GetTable.Request) -> [[CrownsCell]]
    func getPlacements(_ request: CrownsPlayModel.GetPlacements.Request) -> [[Int]]
    func isPlayFinished(_ request: CrownsPlayModel.CheckGameOver.Request) -> Bool
    func pauseButtonTapped(_ request: CrownsPlayModel.PauseGame.Request)
    func placeCrown(_ request: CrownsPlayModel.PlaceCrown.Request)
    func gameIsWon(_ request: CrownsPlayModel.GameIsWon.Request)
    func leaveGame(_ request: CrownsPlayModel.LeaveGame.Request)
    func timeIsUp() -> Bool
    func startTimer(_ request: CrownsPlayModel.StartTimer.Request)
    func hintButtonTapped(_ request: CrownsPlayModel.GetHint.Request)
    func saveMove(_ request: CrownsPlayModel.SaveMove.Request)
    func undoButtonTapped(_ request: CrownsPlayModel.UndoMove.Request)
}

struct CrownsMove {
    let indexPath: IndexPath
    let value: Int
}

final class CrownsPlayInteractor: CrownsPlayBusinessLogic {
    
    private let presenter: CrownsPlayPresentationLogic
    private let crowns: Crowns
    private var elapsedTime: Int
    private var initialTime: Int
    private var isTimerUsed: Bool
    private var placements: [[Int]]
    private var timer: Timer? = Timer()
    private var timeGoes: Bool = true
    private var savedMoves: [CrownsMove] = []
    
    init(presenter: CrownsPlayPresentationLogic, foundation: CrownsPlayModel.BuildModule.BuildFoundation) {
        self.presenter = presenter
        self.crowns = foundation.crowns
        self.elapsedTime = foundation.elapsedTime
        self.initialTime = foundation.initialTime
        self.isTimerUsed = foundation.isTimerUsed
        self.placements = foundation.placements
    }
    
    func startTimer(_ request: CrownsPlayModel.StartTimer.Request) {
        initTimer()
    }
    
    @objc private func reverseTimeChange() {
        if initialTime - elapsedTime > 0 {
            elapsedTime += 1
            presenter.presentTime(CrownsPlayModel.SetTime.Response(time: initialTime - elapsedTime))
        } else {
            playFinished(isWin: "lose")
        }
    }
    
    @objc private func forwardTimeChange() {
        elapsedTime += 1
        presenter.presentTime(CrownsPlayModel.SetTime.Response(time: elapsedTime))
    }
    
    func placeCrown(_ request: CrownsPlayModel.PlaceCrown.Request) {
        placements[request.row][request.col] = request.isPlaced
    }
    
    func getTable(_ request: CrownsPlayModel.GetTable.Request) -> [[CrownsCell]] {
        return crowns.puzzle
    }
    
    func getPlacements(_ request: CrownsPlayModel.GetPlacements.Request) -> [[Int]] {
        return self.placements
    }
    
    func backButtonTapped(_ request: CrownsPlayModel.RouteBack.Request) {
        deinitTimer()
        presenter.roureBack(CrownsPlayModel.RouteBack.Response())
    }
    
    func undoButtonTapped(_ request: CrownsPlayModel.UndoMove.Request) {
        if !savedMoves.isEmpty {
            if let indexPath = savedMoves.last?.indexPath, let crownsMove = savedMoves.last {
                placements[indexPath.item / 9][indexPath.item % 9] = crownsMove.value
                presenter.showUndoMove(CrownsPlayModel.UndoMove.Response(move: crownsMove, color: crowns.table[indexPath.item / 9][indexPath.item % 9].color.uiColor))
                savedMoves.remove(at: savedMoves.count - 1)
            }
        }
    }
    
    func hintButtonTapped(_ request: CrownsPlayModel.GetHint.Request) {
        for i in 0...8 {
            for j in 0...8 {
                if crowns.table[i][j].hasCrown && placements[i][j] != 2 {
                    placements[i][j] = 2
                    presenter.showHint(CrownsPlayModel.GetHint.Response(row: i, col: j, color: crowns.table[i][j].color.uiColor))
                    return
                }
            }
        }
    }
    
    func isPlayFinished(_ request: CrownsPlayModel.CheckGameOver.Request) -> Bool {
        var counter = 0
        let table = crowns.table
        for i in 0..<9 {
            for j in 0..<9 {
                if table[i][j].hasCrown == true {
                    if placements[i][j] == 2 {
                        counter += 1
                    } else {
                        return false
                    }
                }
            }
        }
        if counter == 9 {
            return true
        }
        return false
    }
    
    func gameIsWon(_ request: CrownsPlayModel.GameIsWon.Request) {
        playFinished(isWin: "win")
    }
    
    func pauseButtonTapped(_ request: CrownsPlayModel.PauseGame.Request) {
        if timeGoes {
            deinitTimer()
        } else {
            initTimer()
        }
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
    
    func timeIsUp() -> Bool {
        return elapsedTime >= initialTime && isTimerUsed
    }
    
    func saveMove(_ request: CrownsPlayModel.SaveMove.Request) {
        if savedMoves.count > 10 {
            savedMoves.remove(at: 0)
        }
        savedMoves.append(request.move)
        print(savedMoves)
    }
    
    private func playFinished(isWin: String) {
        presenter.routeGameOver(CrownsPlayModel.RouteGameOver.Response(isWin: isWin))
    }
    
    private func initTimer() {
        timeGoes = true
        if isTimerUsed {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reverseTimeChange), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(forwardTimeChange), userInfo: nil, repeats: true)
        }
    }
    
    private func deinitTimer() {
        timeGoes = false
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
