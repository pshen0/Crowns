//
//  ChallengePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation

protocol ChallengePresenterProtocol: AnyObject {
    func viewDidLoaded()
}

class ChallengePresenter: ChallengePresenterProtocol {
    weak var view: ChallengeViewProtocol?
    var router: ChallengeRouterProtocol
    var interactor: ChallengeInteractorProtocol
    
    init(interactor: ChallengeInteractorProtocol, router: ChallengeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoaded() {
        //
    }

}
