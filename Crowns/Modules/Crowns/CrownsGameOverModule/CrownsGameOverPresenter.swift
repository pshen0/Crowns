//
//  GameOverPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation

protocol CrownsGameOverPresentationLogic {
    func routeHome(_ response: CrownsGameOverModel.RouteHome.Response)
    func routeStatistics(_ response: CrownsGameOverModel.RouteStatistics.Response)
}

final class CrownsGameOverPresenter: CrownsGameOverPresentationLogic {
    
    weak var view: CrownsGameOverViewController?
    
    func routeHome(_ response: CrownsGameOverModel.RouteHome.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeStatistics(_ response: CrownsGameOverModel.RouteStatistics.Response) {
        view?.navigationController?.pushViewController(StatisticsBuilder.build(), animated: false)
    }
}
