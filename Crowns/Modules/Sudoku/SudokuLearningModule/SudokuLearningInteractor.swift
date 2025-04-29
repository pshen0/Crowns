//
//  SudokuLearningInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

// MARK: - SudokuLearningBusinessLogic protocol
protocol SudokuLearningBusinessLogic {
    func backButtonTapped(_ request: SudokuLearningModel.RouteBack.Request)
}

// MARK: - SudokuLearningInteractor class
final class SudokuLearningInteractor: SudokuLearningBusinessLogic {
    
    // MARK: - Properties
    private let presenter: SudokuLearningPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: SudokuLearningPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Funcs
    func backButtonTapped(_ request: SudokuLearningModel.RouteBack.Request) {
        presenter.routeBack(SudokuLearningModel.RouteBack.Response())
    }
}
