//
//  SudokuSettingsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation

protocol SudokuSettingsPresentationLogic {
    func routeSudokuGame(_ response: SudokuSettingsModel.RouteSudokuGame.Response)
    func routeBack(_ response: SudokuSettingsModel.RouteBack.Response)
}

final class SudokuSettingsPresenter: SudokuSettingsPresentationLogic {
    
    weak var view: SudokuSettingsViewController?
    
    func routeSudokuGame(_ response: SudokuSettingsModel.RouteSudokuGame.Response) {
        var time: Int = 0
        if let minutes = Int(response.timerLabel.prefix(Constants.timePrefix)) {
            if let seconds = Int(response.timerLabel.suffix(Constants.timeSufix)) {
                time = minutes * 60 + seconds
            }
        }
        
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(SudokuPlayModel.BuildModule.BuildFoundation(
            killerSudoku: KillerSudoku(difficultyLevel: response.difficultyLevel),
            elapsedTime: Constants.elapsedTime,
            initialTime: time,
            isTimerUsed: time == 0 ? false : true)), animated: false)
    }
    
    func routeBack(_ response: SudokuSettingsModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
    
    private enum Constants {
        static let elapsedTime = 0
        static let timePrefix = 2
        static let timeSufix = 2
    }
}
