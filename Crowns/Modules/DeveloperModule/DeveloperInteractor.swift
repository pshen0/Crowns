//
//  DeveloperInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

protocol DeveloperBusinessLogic {
    func backButtonTapped(_ request: DeveloperModel.RouteBack.Request)
}

final class DeveloperInteractor: DeveloperBusinessLogic {
    
    private let presenter: DeveloperPresentationLogic
    
    init(presenter: DeveloperPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: DeveloperModel.RouteBack.Request) {
        presenter.routeBack(DeveloperModel.RouteBack.Response())
    }
}
