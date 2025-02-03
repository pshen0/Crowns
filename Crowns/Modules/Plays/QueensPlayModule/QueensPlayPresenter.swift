//
//  QueensPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol QueensPlayPresenterProtocol: AnyObject {
    func viewDidLoaded()
}

class QueensPlayPresenter: QueensPlayPresenterProtocol {
    weak var view: QueensPlayViewProtocol?
    var router: QueensPlayRouterProtocol
    var interactor: QueensPlayInteractorProtocol
    
    init(interactor: QueensPlayInteractorProtocol, router: QueensPlayRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoaded() {
        //
    }

}
