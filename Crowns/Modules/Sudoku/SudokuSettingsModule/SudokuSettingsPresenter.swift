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
        var time: SudokuPlayModel.Time = SudokuPlayModel.Time(minutes: 0, seconds: 0)
        if let minutes = Int(response.timerLabel.prefix(2)) {
            if let seconds = Int(response.timerLabel.suffix(2)) {
                time = SudokuPlayModel.Time(minutes: minutes, seconds: seconds)
            }
        } else {
            time = SudokuPlayModel.Time(minutes: 0, seconds: 0)
        }
        
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(SudokuPlayModel.BuildModule.BuildFoundation(difficultyLevel: response.difficultyLevel, time: time)), animated: false)
    }
    
    func routeBack(_ response: SudokuSettingsModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
