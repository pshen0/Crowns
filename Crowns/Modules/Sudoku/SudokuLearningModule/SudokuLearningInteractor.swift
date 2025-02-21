//
//  SudokuLearningInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol SudokuLearningBusinessLogic {
    func backButtonTapped(_ request: SudokuLearningModel.RouteBack.Request)
}

final class SudokuLearningInteractor: SudokuLearningBusinessLogic {
    
    private let presenter: SudokuLearningPresentationLogic
    
    init(presenter: SudokuLearningPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: SudokuLearningModel.RouteBack.Request) {
        presenter.routeBack(SudokuLearningModel.RouteBack.Response())
    }
}
