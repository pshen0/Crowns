//
//  GameOverPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation

// MARK: - CrownsGameOverPresentationLogic protocol
protocol CrownsGameOverPresentationLogic {
    func routeHome(_ response: CrownsGameOverModel.RouteHome.Response)
    func routeStatistics(_ response: CrownsGameOverModel.RouteStatistics.Response)
}

// MARK: - CrownsGameOverPresenter class
final class CrownsGameOverPresenter: CrownsGameOverPresentationLogic {
    
    // MARK: - Properties
    weak var view: CrownsGameOverViewController?
    
    // MARK: - Funcs
    func routeHome(_ response: CrownsGameOverModel.RouteHome.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeStatistics(_ response: CrownsGameOverModel.RouteStatistics.Response) {
        view?.navigationController?.pushViewController(StatisticsBuilder.build(game: StatisticsModel.GameType.crowns), animated: false)
    }
}
