//
//  SudokuPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol SudokuPlayPresenterProtocol: AnyObject {
}

class SudokuPlayPresenter: SudokuPlayPresenterProtocol {
    weak var view: SudokuPlayViewProtocol?
    var router: SudokuPlayRouterProtocol
    var interactor: SudokuPlayInteractorProtocol
    
    init(interactor: SudokuPlayInteractorProtocol, router: SudokuPlayRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

}
