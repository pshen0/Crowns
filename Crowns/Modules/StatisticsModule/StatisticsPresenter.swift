//
//  StatisticsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

protocol StatisticsPresentationLogic {
    func routeBack(_ response: StatisticsModel.RouteBack.Response)
}

final class StatisticsPresenter: StatisticsPresentationLogic {
    
    weak var view: StatisticsViewController?
    
    func routeBack(_ response: StatisticsModel.RouteBack.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
}
