//
//  SudokuPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

// MARK: - SudokuPlayPresentationLogic protocol
protocol SudokuPlayPresentationLogic {
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response)
    func routeGameOver(_ response: SudokuPlayModel.RouteGameOver.Response)
    func presentTime (_ response: SudokuPlayModel.SetTime.Response)
    func setPlaygroundChanges(_ response: SudokuPlayModel.ChangeCell.Response)
    func setLevelImage(_ response: SudokuPlayModel.GetLevel.Response)
}

// MARK: - SudokuPlayPresenter class
final class SudokuPlayPresenter: SudokuPlayPresentationLogic {
    
    // MARK: - Properties
    weak var view: SudokuPlayViewController?
    
    // MARK: - Funcs
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeGameOver(_ response: SudokuPlayModel.RouteGameOver.Response) {
        view?.navigationController?.pushViewController(SudokuGameOverBuilder.build(isWin: response.isWin, time: getStringTime(response.time )), animated: false)
    }
    
    func presentTime (_ response: SudokuPlayModel.SetTime.Response) {
        view?.setTimerLabel(SudokuPlayModel.SetTime.ViewModel(timerLabel: getStringTime(response.time)))
    }
    
    func setPlaygroundChanges(_ response: SudokuPlayModel.ChangeCell.Response) {
        view?.presentChanges(SudokuPlayModel.ChangeCell.ViewModel(changes: response.changes))
    }
    
    func setLevelImage(_ response: SudokuPlayModel.GetLevel.Response) {
        view?.setLevelPicture(SudokuPlayModel.GetLevel.ViewModel(image: response.image))
    }
    
    // MARK: - Private funcs
    private func getStringTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        let minutesStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsStr = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let timerLabel = minutesStr + ":" + secondsStr
        return timerLabel
    }
}
