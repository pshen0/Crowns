//
//  SudokuSettingsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation


protocol SudokuSettingsBusinessLogic {
    func startButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request)
    func backButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request)
}

final class SudokuSettingsInteractor: SudokuSettingsBusinessLogic {
    
    private let presenter: SudokuSettingsPresentationLogic
    
    init(presenter: SudokuSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    func startButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request) {
        presenter.routeSudokuGame(SudokuSettingsModel.RouteSudokuGame.Response())
    }
    
    func backButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request) {
        presenter.routeBack(SudokuSettingsModel.RouteBack.Response())
    }
}
