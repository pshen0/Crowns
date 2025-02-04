//
//  CrownsLearningPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol CrownsLearningPresenterProtocol: AnyObject {
    func processBackButton()
}

class CrownsLearningPresenter: CrownsLearningPresenterProtocol {
    weak var view: CrownsLearningViewProtocol?
    var router: CrownsLearningRouterProtocol
    var interactor: CrownsLearningInteractorProtocol
    
    init(interactor: CrownsLearningInteractorProtocol, router: CrownsLearningRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func processBackButton() {
        router.navigateBack()
    }

}
