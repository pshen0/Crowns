//
//  SudokuPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol SudokuPlayBusinessLogic {
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request)
}

final class SudokuPlayInteractor: SudokuPlayBusinessLogic {
    
    private let presenter: SudokuPlayPresentationLogic
    
    init(presenter: SudokuPlayPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request) {
        presenter.routeBack(SudokuPlayModel.RouteBack.Response())
    }
}
