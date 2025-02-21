//
//  CrownsSettingsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation


protocol CrownsSettingsBusinessLogic {
    func startButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request)
    func backButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request)
}

final class CrownsSettingsInteractor: CrownsSettingsBusinessLogic {
    
    private let presenter: CrownsSettingsPresentationLogic
    
    init(presenter: CrownsSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    func startButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request) {
        presenter.routeCrownsGame(CrownsSettingsModel.RouteCrownsGame.Response())
    }
    
    func backButtonTapped(_ request: CrownsSettingsModel.RouteBack.Request) {
        presenter.routeBack(CrownsSettingsModel.RouteBack.Response())
    }
}
