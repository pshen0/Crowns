//
//  StatisticsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

// MARK: - StatisticsPresentationLogic protocol
protocol StatisticsPresentationLogic {
    func routeBack(_ response: StatisticsModel.RouteBack.Response)
    func setGameType(_ response: StatisticsModel.OpenStatistics.Response)
}

// MARK: - StatisticsPresenter class
final class StatisticsPresenter: StatisticsPresentationLogic {
    
    // MARK: - Properties
    weak var view: StatisticsViewController?
    
    // MARK: - Funcs
    func routeBack(_ response: StatisticsModel.RouteBack.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func setGameType(_ response: StatisticsModel.OpenStatistics.Response) {
        view?.setGameType(StatisticsModel.OpenStatistics.ViewModel(gameType: response.gameType))
    }
}
