//
//  SudokuSettingsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation


protocol SudokuSettingsBusinessLogic {
    func startButtonTapped(_ request: SudokuSettingsModel.RouteSudokuGame.Request)
    func backButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request)
}

final class SudokuSettingsInteractor: SudokuSettingsBusinessLogic {
    
    private let presenter: SudokuSettingsPresentationLogic
    private var chosenDifficultyLevel: String = "Easy"
    
    
    init(presenter: SudokuSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    func startButtonTapped(_ request: SudokuSettingsModel.RouteSudokuGame.Request) {
        switch request.buttonTag {
        case 0:
            chosenDifficultyLevel = "Easy"
        case 1:
            chosenDifficultyLevel = "Medium"
        case 2:
            chosenDifficultyLevel = "Hard"
        default:
            chosenDifficultyLevel = ["Easy", "Medium", "Hard"].randomElement() ?? "Easy"
        }
        presenter.routeSudokuGame(SudokuSettingsModel.RouteSudokuGame.Response(difficultyLevel: chosenDifficultyLevel, timerLabel: request.timerLabel))
    }
    
    func backButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request) {
        presenter.routeBack(SudokuSettingsModel.RouteBack.Response())
    }
}
