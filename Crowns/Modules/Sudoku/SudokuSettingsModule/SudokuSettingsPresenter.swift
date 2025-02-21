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
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(), animated: false)
    }
    
    func routeBack(_ response: SudokuSettingsModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
