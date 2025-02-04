//
//  SudokuLearningPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol SudokuLearningPresenterProtocol: AnyObject {
    func processBackButton()
}

class SudokuLearningPresenter: SudokuLearningPresenterProtocol {
    weak var view: SudokuLearningViewProtocol?
    var router: SudokuLearningRouterProtocol
    var interactor: SudokuLearningInteractorProtocol
    
    init(interactor: SudokuLearningInteractorProtocol, router: SudokuLearningRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func processBackButton() {
        router.navigateBack()
    }

}
