//
//  Presenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoaded()
    func processLearningButton(for game: Int)
    func processPlayButton(for game: Int)
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
    
    func processLearningButton(for game: Int) {
        router.navigateToLearning(for: game)
    }
    
    func processPlayButton(for game: Int) {
        router.navigateToPlaySettings(for: game)
    }
}
