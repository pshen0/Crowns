//
//  CrownsPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol CrownsPlayPresentationLogic {
    func roureBack(_ response: CrownsPlayModel.RouteBack.Response)
    func routeGameOver(_ response: CrownsPlayModel.RouteGameOver.Response)
    func presentTime (_ response: CrownsPlayModel.SetTime.Response)
}

final class CrownsPlayPresenter: CrownsPlayPresentationLogic {
    
    weak var view: CrownsPlayViewController?
    
    func roureBack(_ response: CrownsPlayModel.RouteBack.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeGameOver(_ response: CrownsPlayModel.RouteGameOver.Response) {
        let gameOverViewController = SudokuGameOverBuilder.build()
        gameOverViewController.isWin = response.isWin
        view?.navigationController?.pushViewController(gameOverViewController, animated: false)
    }
    
    func presentTime (_ response: CrownsPlayModel.SetTime.Response) {
        let minutesStr = response.time.minutes < 10 ? "0\(response.time.minutes)" : "\(response.time.minutes)"
        let secondsStr = response.time.seconds < 10 ? "0\(response.time.seconds)" : "\(response.time.seconds)"
        let timerLabel = minutesStr + ":" + secondsStr
        view?.setTimerLabel(CrownsPlayModel.SetTime.ViewModel(timerLabel: timerLabel))
    }
}
