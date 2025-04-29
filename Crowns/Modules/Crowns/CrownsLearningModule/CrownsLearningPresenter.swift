//
//  CrownsLearningPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

// MARK: - CrownsLearningPresentationLogic protocol
protocol CrownsLearningPresentationLogic {
    func routeBack(_ response: CrownsLearningModel.RouteBack.Response)
}

// MARK: - CrownsLearningPresenter class
final class CrownsLearningPresenter: CrownsLearningPresentationLogic {
    
    // MARK: - Properties
    weak var view: CrownsLearningViewController?

    // MARK: - Funcs
    func routeBack(_ response: CrownsLearningModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
