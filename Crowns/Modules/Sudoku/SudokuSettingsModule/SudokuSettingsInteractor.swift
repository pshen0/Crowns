//
//  SudokuSettingsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation

// MARK: - SudokuSettingsBusinessLogic protocol
protocol SudokuSettingsBusinessLogic {
    func startButtonTapped(_ request: SudokuSettingsModel.RouteSudokuGame.Request)
    func backButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request)
}

// MARK: - SudokuSettingsInteractor class
final class SudokuSettingsInteractor: SudokuSettingsBusinessLogic {
    
    // MARK: - Properties
    private let presenter: SudokuSettingsPresentationLogic
    private var chosenDifficultyLevel: String = DifficultyLevels.easy
    
    // MARK: - Lifecycle
    init(presenter: SudokuSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Funcs
    func startButtonTapped(_ request: SudokuSettingsModel.RouteSudokuGame.Request) {
        switch request.buttonTag {
        case Constants.easyTag:
            chosenDifficultyLevel = DifficultyLevels.easy
        case Constants.mediumTag:
            chosenDifficultyLevel = DifficultyLevels.medium
        case Constants.hardTag:
            chosenDifficultyLevel = DifficultyLevels.hard
        default:
            if let difficulty = [DifficultyLevels.easy, DifficultyLevels.medium, DifficultyLevels.hard].randomElement() {
                chosenDifficultyLevel = difficulty
            }
        }
        presenter.routeSudokuGame(SudokuSettingsModel.RouteSudokuGame.Response(difficultyLevel: chosenDifficultyLevel, timerLabel: request.timerLabel))
    }
    
    func backButtonTapped(_ request: SudokuSettingsModel.RouteBack.Request) {
        presenter.routeBack(SudokuSettingsModel.RouteBack.Response())
    }
    
    // MARK: - Constants
    private enum Constants {
        static let easyTag: Int = 0
        static let mediumTag: Int = 1
        static let hardTag: Int = 2
        static let randomTag: Int = 3
    }
}
