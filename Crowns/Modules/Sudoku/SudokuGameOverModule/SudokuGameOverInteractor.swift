//
//  SudokuGameOverInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import UIKit

// MARK: - SudokuGameOverBusinessLogic protocol
protocol SudokuGameOverBusinessLogic {
    func homeButtonTapped(_ request: SudokuGameOverModel.RouteHome.Request)
    func statisticsButtonTapped(_ request: SudokuGameOverModel.RouteStatistics.Request)
    func isWin(_ request: SudokuGameOverModel.IsWin.Request) -> (String, UIImage?)
    func timerLabel(_ request: SudokuGameOverModel.getTime.Request) -> String
}

// MARK: - SudokuGameOverInteractor class
final class SudokuGameOverInteractor: SudokuGameOverBusinessLogic {
    
    // MARK: - Properties
    private let presenter: SudokuGameOverPresentationLogic
    private let isWin: Bool
    private let timerLabel: String
    
    // MARK: - Lifecycle
    init(presenter: SudokuGameOverPresentationLogic, isWin: Bool, time: String) {
        self.presenter = presenter
        self.isWin = isWin
        self.timerLabel = time
    }
    
    // MARK: - Funcs
    func homeButtonTapped(_ request: SudokuGameOverModel.RouteHome.Request) {
        presenter.routeHome(SudokuGameOverModel.RouteHome.Response())
    }
    
    func statisticsButtonTapped(_ request: SudokuGameOverModel.RouteStatistics.Request) {
        presenter.routeStatistics(SudokuGameOverModel.RouteStatistics.Response())
    }
    
    func isWin(_ request: SudokuGameOverModel.IsWin.Request) -> (String, UIImage?) {
        let text = isWin ? Constants.victoty : Constants.defeat
        let image = isWin ? UIImage.winningCat : UIImage.losingCat
        return (text, image)
    }
    
    func timerLabel(_ request: SudokuGameOverModel.getTime.Request) -> String {
        return timerLabel
    }
    
    // MARK: - Constants
    private enum Constants {
        static let victoty = "Victory!"
        static let defeat = "Defeat"
    }
}
