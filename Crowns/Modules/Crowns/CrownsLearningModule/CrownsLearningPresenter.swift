//
//  CrownsLearningPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//


protocol CrownsLearningPresentationLogic {
    func routeBack(_ response: CrownsLearningModel.RouteBack.Response)
}

final class CrownsLearningPresenter: CrownsLearningPresentationLogic {
    
    weak var view: CrownsLearningViewController?

    func routeBack(_ response: CrownsLearningModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
