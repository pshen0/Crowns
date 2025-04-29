//
//  GameOverInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation
import UIKit

// MARK: - CrownsGameOverBusinessLogic protocol
protocol CrownsGameOverBusinessLogic {
    func homeButtonTapped(_ request: CrownsGameOverModel.RouteHome.Request)
    func statisticsButtonTapped(_ request: CrownsGameOverModel.RouteStatistics.Request)
    func isWin(_ request: CrownsGameOverModel.IsWin.Request) -> (String, UIImage?)
    func timerLabel(_ request: CrownsGameOverModel.getTime.Request) -> String
}

// MARK: - CrownsGameOverInteractor class
final class CrownsGameOverInteractor: CrownsGameOverBusinessLogic {
    
    // MARK: - Properties
    private let presenter: CrownsGameOverPresentationLogic
    private let isWin: Bool
    private let timerLabel: String
    
    // MARK: - Lifecycle
    init(presenter: CrownsGameOverPresentationLogic, isWin: Bool, time: String) {
        self.presenter = presenter
        self.isWin = isWin
        self.timerLabel = time
    }
    
    // MARK: - Funcs
    func homeButtonTapped(_ request: CrownsGameOverModel.RouteHome.Request) {
        presenter.routeHome(CrownsGameOverModel.RouteHome.Response())
    }
    
    func statisticsButtonTapped(_ request: CrownsGameOverModel.RouteStatistics.Request) {
        presenter.routeStatistics(CrownsGameOverModel.RouteStatistics.Response())
    }
    
    func isWin(_ request: CrownsGameOverModel.IsWin.Request) -> (String, UIImage?) {
        let text = isWin ? Constants.victoty : Constants.defeat
        let image = isWin ? UIImage.winningCat : UIImage.losingCat
        return (text, image)
    }
    
    func timerLabel(_ request: CrownsGameOverModel.getTime.Request) -> String {
        return timerLabel
    }
    
    // MARK: - Constants
    private enum Constants {
        static let victoty = "Victory!"
        static let defeat = "Defeat"
    }
}
