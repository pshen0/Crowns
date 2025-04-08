//
//  GameOverInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation

protocol CrownsGameOverBusinessLogic {
    func homeButtonTapped(_ request: CrownsGameOverModel.RouteHome.Request)
}

final class CrownsGameOverInteractor: CrownsGameOverBusinessLogic {
    
    private let presenter: CrownsGameOverPresentationLogic
    private let isWin: String
    
    init(presenter: CrownsGameOverPresentationLogic, _ isWin: String) {
        self.presenter = presenter
        self.isWin = isWin
    }
    
    func homeButtonTapped(_ request: CrownsGameOverModel.RouteHome.Request) {
        presenter.routeHome(CrownsGameOverModel.RouteHome.Response())
    }
}
