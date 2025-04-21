//
//  GameOverInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation
import UIKit

protocol CrownsGameOverBusinessLogic {
    func homeButtonTapped(_ request: CrownsGameOverModel.RouteHome.Request)
    func statisticsButtonTapped(_ request: CrownsGameOverModel.RouteStatistics.Request)
    func isWin(_ request: CrownsGameOverModel.IsWin.Request) -> (String, UIImage?)
    func timerLabel(_ request: CrownsGameOverModel.getTime.Request) -> String
}

final class CrownsGameOverInteractor: CrownsGameOverBusinessLogic {
    
    private let presenter: CrownsGameOverPresentationLogic
    private let isWin: Bool
    private let timerLabel: String
    
    init(presenter: CrownsGameOverPresentationLogic, isWin: Bool, time: String) {
        self.presenter = presenter
        self.isWin = isWin
        self.timerLabel = time
    }
    
    func homeButtonTapped(_ request: CrownsGameOverModel.RouteHome.Request) {
        presenter.routeHome(CrownsGameOverModel.RouteHome.Response())
    }
    
    func statisticsButtonTapped(_ request: CrownsGameOverModel.RouteStatistics.Request) {
        presenter.routeStatistics(CrownsGameOverModel.RouteStatistics.Response())
    }
    
    func isWin(_ request: CrownsGameOverModel.IsWin.Request) -> (String, UIImage?) {
        let text = isWin ? "Victory!" : "Defeat"
        let image = isWin ? Images.winningCat : Images.losingCat
        return (text, image)
    }
    
    func timerLabel(_ request: CrownsGameOverModel.getTime.Request) -> String {
        return timerLabel
    }
}
