//
//  CrownsLearningInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol CrownsLearningBusinessLogic {
    func backButtonTapped(_ request: CrownsLearningModel.RouteBack.Request)
}

final class CrownsLearningInteractor: CrownsLearningBusinessLogic {
    
    private let presenter: CrownsLearningPresentationLogic
    
    init(presenter: CrownsLearningPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: CrownsLearningModel.RouteBack.Request) {
        presenter.routeBack(CrownsLearningModel.RouteBack.Response())
    }
}
