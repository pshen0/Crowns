//
//  CrownsSettingsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation


protocol CrownsSettingsBusinessLogic {
    func startButtonTapped(_ request: CrownsSettingsModel.RouteCrownsGame.Request)
    func backButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request)
}

final class CrownsSettingsInteractor: CrownsSettingsBusinessLogic {
    
    private let presenter: CrownsSettingsPresentationLogic
    private var chosenDifficultyLevel: String = Text.easyTag
    
    init(presenter: CrownsSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    func startButtonTapped(_ request: CrownsSettingsModel.RouteCrownsGame.Request) {
        switch request.buttonTag {
        case 0:
            chosenDifficultyLevel = Text.easyTag
        case 1:
            chosenDifficultyLevel = Text.mediumTag
        case 2:
            chosenDifficultyLevel = Text.hardTag
        default:
            chosenDifficultyLevel = [Text.easyTag, Text.mediumTag, Text.hardTag].randomElement() ?? Text.easyTag
        }
        presenter.routeCrownsGame(CrownsSettingsModel.RouteCrownsGame.Response(difficultyLevel: chosenDifficultyLevel, timerLabel: request.timerLabel))
    }
    
    func backButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request) {
        presenter.routeBack(CrownsSettingsModel.RouteBack.Response())
    }
}
