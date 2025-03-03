//
//  StatisticsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

protocol StatisticsBusinessLogic {
    func backButtonTapped(_ request: StatisticsModel.RouteBack.Request)
}

final class StatisticsInteractor: StatisticsBusinessLogic {
    
    private let presenter: StatisticsPresentationLogic
    
    init(presenter: StatisticsPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: StatisticsModel.RouteBack.Request) {
        presenter.routeBack(StatisticsModel.RouteBack.Response())
    }
}
