//
//  Presenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoaded()
    func learningButtonTapped(for game: String)
    func playButtonTapped(for game: String)
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    var router: HomeRouterProtocol
    var interactor: HomeInteractorProtocol 
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router 
    }
    
    func viewDidLoaded() {
        //
    }
    
    func learningButtonTapped(for game: String) {
        router.navigateToLearning(for: game)
    }
    
    func playButtonTapped(for game: String) {
        router.navigateToPlaySettings(for: game)
    }
}
