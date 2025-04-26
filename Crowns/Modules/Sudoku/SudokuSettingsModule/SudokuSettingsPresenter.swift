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
        if let minutes = Int(response.timerLabel.prefix(2)) {
            if let seconds = Int(response.timerLabel.suffix(2)) {
                time = minutes * 60 + seconds
            }
        }
        
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(SudokuPlayModel.BuildModule.BuildFoundation(
            killerSudoku: KillerSudoku(difficultyLevel: response.difficultyLevel),
            elapsedTime: 0,
            initialTime: time,
            isTimerUsed: time == 0 ? false : true)), animated: false)
    }
    
    func routeBack(_ response: SudokuSettingsModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
