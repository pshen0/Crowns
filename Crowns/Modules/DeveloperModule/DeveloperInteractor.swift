//
//  DeveloperInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

// MARK: - DeveloperBusinessLogic protocol
protocol DeveloperBusinessLogic {
    func backButtonTapped(_ request: DeveloperModel.RouteBack.Request)
}

// MARK: - DeveloperInteractor class
final class DeveloperInteractor: DeveloperBusinessLogic {
    
    // MARK: - Properties
    private let presenter: DeveloperPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: DeveloperPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Funcs
    func backButtonTapped(_ request: DeveloperModel.RouteBack.Request) {
        presenter.routeBack(DeveloperModel.RouteBack.Response())
    }
}
