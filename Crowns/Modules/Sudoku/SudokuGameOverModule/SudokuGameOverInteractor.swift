//
//  SudokuGameOverInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import Foundation

protocol SudokuGameOverBusinessLogic {
    func homeButtonTapped(_ request: SudokuGameOverModel.RouteHome.Request)
}

final class SudokuGameOverInteractor: SudokuGameOverBusinessLogic {
    
    private let presenter: SudokuGameOverPresentationLogic
    
    init(presenter: SudokuGameOverPresentationLogic) {
        self.presenter = presenter
    }
    
    func homeButtonTapped(_ request: SudokuGameOverModel.RouteHome.Request) {
        presenter.routeHome(SudokuGameOverModel.RouteHome.Response())
    }
}
