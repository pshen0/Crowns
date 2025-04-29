//
//  SudokuGameOverPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import Foundation

// MARK: - SudokuGameOverPresentationLogicn protocol
protocol SudokuGameOverPresentationLogic {
    func routeHome(_ response: SudokuGameOverModel.RouteHome.Response)
    func routeStatistics(_ response: SudokuGameOverModel.RouteStatistics.Response)
}

// MARK: - SudokuGameOverPresenter class
final class SudokuGameOverPresenter: SudokuGameOverPresentationLogic {
    
    // MARK: - Properties
    weak var view: SudokuGameOverViewController?
    
    // MARK: - Funcs
    func routeHome(_ response: SudokuGameOverModel.RouteHome.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeStatistics(_ response: SudokuGameOverModel.RouteStatistics.Response) {
        view?.navigationController?.pushViewController(StatisticsBuilder.build(game: StatisticsModel.GameType.killerSudoku), animated: false)
    }
}
