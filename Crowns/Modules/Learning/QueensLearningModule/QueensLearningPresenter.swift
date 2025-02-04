//
//  QueensLearningPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol QueensLearningPresenterProtocol: AnyObject {
    func processBackButton()
}

class QueensLearningPresenter: QueensLearningPresenterProtocol {
    weak var view: QueensLearningViewProtocol?
    var router: QueensLearningRouterProtocol
    var interactor: QueensLearningInteractorProtocol
    
    init(interactor: QueensLearningInteractorProtocol, router: QueensLearningRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func processBackButton() {
        router.navigateBack()
    }
}
