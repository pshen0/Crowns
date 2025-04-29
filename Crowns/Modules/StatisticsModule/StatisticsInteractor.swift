//
//  StatisticsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

// MARK: - StatisticsBusinessLogic protocol
protocol StatisticsBusinessLogic {
    func backButtonTapped(_ request: StatisticsModel.RouteBack.Request)
    func getGameType(_ request: StatisticsModel.OpenStatistics.Request)
}

// MARK: - StatisticsInteractor class
final class StatisticsInteractor: StatisticsBusinessLogic {
    
    // MARK: - Properties
    private let presenter: StatisticsPresentationLogic
    private let startGameType: StatisticsModel.GameType
    
    // MARK: - Lifecycle
    init(presenter: StatisticsPresentationLogic, game: StatisticsModel.GameType) {
        self.presenter = presenter
        self.startGameType = game
    }
    
    // MARK: - Funcs
    func backButtonTapped(_ request: StatisticsModel.RouteBack.Request) {
        presenter.routeBack(StatisticsModel.RouteBack.Response())
    }
    
    func getGameType(_ request: StatisticsModel.OpenStatistics.Request) {
        presenter.setGameType(StatisticsModel.OpenStatistics.Response(gameType: startGameType))
    }
}
