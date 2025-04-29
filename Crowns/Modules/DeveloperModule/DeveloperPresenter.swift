//
//  DeveloperPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

// MARK: - DeveloperPresentationLogic protocol
protocol DeveloperPresentationLogic {
    func routeBack(_ response: DeveloperModel.RouteBack.Response)
}

// MARK: - DeveloperPresenter class
final class DeveloperPresenter: DeveloperPresentationLogic {
    
    // MARK: - Properties
    weak var view: DeveloperViewController?
    
    // MARK: - Funcs
    func routeBack(_ response: DeveloperModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
