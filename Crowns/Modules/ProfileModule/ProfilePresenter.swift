//
//  ProfilePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoaded()
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    var router: ProfileRouterProtocol
    var interactor: ProfileInteractorProtocol
    
    init(interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoaded() {
        //
    }

}
