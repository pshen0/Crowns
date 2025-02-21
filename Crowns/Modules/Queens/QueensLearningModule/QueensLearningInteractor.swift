//
//  QueensLearningInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol QueensLearningBusinessLogic {
    func backButtonTapped(_ request: QueensLearningModel.RouteBack.Request)
}

final class QueensLearningInteractor: QueensLearningBusinessLogic {
    
    private let presenter: QueensLearningPresentationLogic
    
    init(presenter: QueensLearningPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: QueensLearningModel.RouteBack.Request) {
        presenter.routeBack(QueensLearningModel.RouteBack.Response())
    }
}
