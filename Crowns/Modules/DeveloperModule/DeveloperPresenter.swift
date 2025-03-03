//
//  DeveloperPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

protocol DeveloperPresentationLogic {
    func routeBack(_ response: DeveloperModel.RouteBack.Response)
}

final class DeveloperPresenter: DeveloperPresentationLogic {
    
    weak var view: DeveloperViewController?
    
    func routeBack(_ response: DeveloperModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
