//
//  CrownsLearningInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

// MARK: - CrownsLearningBusinessLogic protocol
protocol CrownsLearningBusinessLogic {
    func backButtonTapped(_ request: CrownsLearningModel.RouteBack.Request)
}

// MARK: - CrownsLearningInteractor class
final class CrownsLearningInteractor: CrownsLearningBusinessLogic {
    
    // MARK: - Properties
    private let presenter: CrownsLearningPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: CrownsLearningPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Funcs
    func backButtonTapped(_ request: CrownsLearningModel.RouteBack.Request) {
        presenter.routeBack(CrownsLearningModel.RouteBack.Response())
    }
}
