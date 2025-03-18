//
//  SudokuPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SudokuPlayPresentationLogic {
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response)
    func routeGameOver(_ response: SudokuPlayModel.RouteGameOver.Response)
    func presentTime (_ response: SudokuPlayModel.SetTime.Response)
}

final class SudokuPlayPresenter: SudokuPlayPresentationLogic {
    
    weak var view: SudokuPlayViewController?
    
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeGameOver(_ response: SudokuPlayModel.RouteGameOver.Response) {
        let gameOverViewController = SudokuGameOverBuilder.build()
        gameOverViewController.isWin = response.isWin
        view?.navigationController?.pushViewController(gameOverViewController, animated: false)
    }
    
    func presentTime (_ response: SudokuPlayModel.SetTime.Response) {
        let minutesStr = response.time.minutes < 10 ? "0\(response.time.minutes)" : "\(response.time.minutes)"
        let secondsStr = response.time.seconds < 10 ? "0\(response.time.seconds)" : "\(response.time.seconds)"
        let timerLabel = minutesStr + ":" + secondsStr
        view?.setTimerLabel(SudokuPlayModel.SetTime.ViewModel(timerLabel: timerLabel))
    }
}
