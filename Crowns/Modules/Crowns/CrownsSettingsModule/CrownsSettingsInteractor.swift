//
//  CrownsSettingsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation

// MARK: - CrownsSettingsBusinessLogic protocol
protocol CrownsSettingsBusinessLogic {
    func startButtonTapped(_ request: CrownsSettingsModel.RouteCrownsGame.Request)
    func backButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request)
}

// MARK: - CrownsSettingsInteractor class
final class CrownsSettingsInteractor: CrownsSettingsBusinessLogic {
    
    // MARK: - Properties
    private let presenter: CrownsSettingsPresentationLogic
    private var chosenDifficultyLevel: String = DifficultyLevels.easy
    
    // MARK: - Lifecycle
    init(presenter: CrownsSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Funcs
    func startButtonTapped(_ request: CrownsSettingsModel.RouteCrownsGame.Request) {
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
        presenter.routeCrownsGame(CrownsSettingsModel.RouteCrownsGame.Response(difficultyLevel: chosenDifficultyLevel, timerLabel: request.timerLabel))
    }
    
    func backButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request) {
        presenter.routeBack(CrownsSettingsModel.RouteBack.Response())
    }
    
    // MARK: - Constants
    private enum Constants {
        static let easyTag: Int = 0
        static let mediumTag: Int = 1
        static let hardTag: Int = 2
        static let randomTag: Int = 3
    }
}
