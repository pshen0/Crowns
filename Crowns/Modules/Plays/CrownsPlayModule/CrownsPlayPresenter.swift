//
//  CrownsPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol CrownsPlayPresenterProtocol: AnyObject {
}

class CrownsPlayPresenter: CrownsPlayPresenterProtocol {
    weak var view: CrownsPlayViewProtocol?
    var router: CrownsPlayRouterProtocol
    var interactor: CrownsPlayInteractorProtocol
    
    init(interactor: CrownsPlayInteractorProtocol, router: CrownsPlayRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

}
