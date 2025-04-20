//
//  GameOverPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation

protocol CrownsGameOverPresentationLogic {
    func routeHome(_ response: CrownsGameOverModel.RouteHome.Response)
}

final class CrownsGameOverPresenter: CrownsGameOverPresentationLogic {
    
    weak var view: CrownsGameOverViewController?
    
    func routeHome(_ response: CrownsGameOverModel.RouteHome.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
}
