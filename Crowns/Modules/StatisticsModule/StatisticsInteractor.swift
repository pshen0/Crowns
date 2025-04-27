//
//  StatisticsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

protocol StatisticsBusinessLogic {
    func backButtonTapped(_ request: StatisticsModel.RouteBack.Request)
    func getGameType(_ request: StatisticsModel.OpenStatistics.Request)
}

final class StatisticsInteractor: StatisticsBusinessLogic {
    
    private let presenter: StatisticsPresentationLogic
    private let startGameType: StatisticsModel.GameType
    
    init(presenter: StatisticsPresentationLogic, game: StatisticsModel.GameType) {
        self.presenter = presenter
        self.startGameType = game
    }
    
    func backButtonTapped(_ request: StatisticsModel.RouteBack.Request) {
        presenter.routeBack(StatisticsModel.RouteBack.Response())
    }
    
    func getGameType(_ request: StatisticsModel.OpenStatistics.Request) {
        presenter.setGameType(StatisticsModel.OpenStatistics.Response(gameType: startGameType))
    }
}
