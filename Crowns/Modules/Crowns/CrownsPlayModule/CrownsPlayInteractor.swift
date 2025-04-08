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
    func isPlayFinished(_ request: CrownsPlayModel.CheckGameOver.Request)
    func pauseButtonTapped(_ request: CrownsPlayModel.PauseGame.Request)
}

final class CrownsPlayInteractor: CrownsPlayBusinessLogic {
    
    private let presenter: CrownsPlayPresentationLogic
    private let crowns: Crowns
    private var time: CrownsPlayModel.Time
    private var timer: Timer? = Timer()
    private var timeGoes: Bool = true
    
    init(presenter: CrownsPlayPresentationLogic, crowns: Crowns, time: CrownsPlayModel.Time) {
        self.presenter = presenter
        self.crowns = crowns
        self.time = time
        startTimer()
    }
    
    private func startTimer() {
        if time.minutes != 0 || time.seconds != 0 {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func changeTime() {
        if time.seconds > 0 {
            time.seconds -= 1
            presenter.presentTime(CrownsPlayModel.SetTime.Response(time: time))
        } else if time.minutes > 0 {
            time.minutes -= 1
            time.seconds = 59
            presenter.presentTime(CrownsPlayModel.SetTime.Response(time: time))
        } else {
            playFinished(isWin: "lose")
        }
    }
    
    func getTable(_ request: CrownsPlayModel.GetTable.Request) -> [[CrownsCell]] {
        return crowns.puzzle
    }
    
    func backButtonTapped(_ request: CrownsPlayModel.RouteBack.Request) {
        presenter.roureBack(CrownsPlayModel.RouteBack.Response())
    }
    
    func isPlayFinished(_ request: CrownsPlayModel.CheckGameOver.Request) {
        var counter = 0
        let table = crowns.table
        for i in 0..<9 {
            for j in 0..<9 {
                if table[i][j].hasCrown == true {
                    if request.crownsPlacements[i][j] == true {
                        counter += 1
                    } else {
                        return
                    }
                }
            }
        }
        print(counter)
        if counter == 9 {
            playFinished(isWin: "win")
        }
    }
    
    func pauseButtonTapped(_ request: CrownsPlayModel.PauseGame.Request) {
        if timeGoes {
            timeGoes = false
            timer?.invalidate()
            timer = nil
        } else {
            timeGoes = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeTime), userInfo: nil, repeats: true)
        }
    }
    
    private func playFinished(isWin: String) {
        presenter.routeGameOver(CrownsPlayModel.RouteGameOver.Response(isWin: isWin))
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
