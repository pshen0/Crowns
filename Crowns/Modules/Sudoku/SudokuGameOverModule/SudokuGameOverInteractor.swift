//
//  SudokuGameOverInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import UIKit

protocol SudokuGameOverBusinessLogic {
    func homeButtonTapped(_ request: SudokuGameOverModel.RouteHome.Request)
    func statisticsButtonTapped(_ request: SudokuGameOverModel.RouteStatistics.Request)
    func isWin(_ request: SudokuGameOverModel.IsWin.Request) -> (String, UIImage?)
    func timerLabel(_ request: SudokuGameOverModel.getTime.Request) -> String
}

final class SudokuGameOverInteractor: SudokuGameOverBusinessLogic {
    
    private let presenter: SudokuGameOverPresentationLogic
    private let isWin: Bool
    private let timerLabel: String
    
    init(presenter: SudokuGameOverPresentationLogic, isWin: Bool, time: String) {
        self.presenter = presenter
        self.isWin = isWin
        self.timerLabel = time
    }
    
    func homeButtonTapped(_ request: SudokuGameOverModel.RouteHome.Request) {
        presenter.routeHome(SudokuGameOverModel.RouteHome.Response())
    }
    
    func statisticsButtonTapped(_ request: SudokuGameOverModel.RouteStatistics.Request) {
        presenter.routeStatistics(SudokuGameOverModel.RouteStatistics.Response())
    }
    
    func isWin(_ request: SudokuGameOverModel.IsWin.Request) -> (String, UIImage?) {
        let text = isWin ? "Victory!" : "Defeat"
        let image = isWin ? Images.winningCat : Images.losingCat
        return (text, image)
    }
    
    func timerLabel(_ request: SudokuGameOverModel.getTime.Request) -> String {
        return timerLabel
    }
}
