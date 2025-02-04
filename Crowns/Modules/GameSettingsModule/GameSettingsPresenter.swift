//
//  GameSettingsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol GameSettingsPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func processStartButton(for game: Int)
    func processBackButton()
}

class GameSettingsPresenter: GameSettingsPresenterProtocol {
    weak var view: GameSettingsViewProtocol?
    var router: GameSettingsRouterProtocol
    var interactor: GameSettingsInteractorProtocol
    
    init(interactor: GameSettingsInteractorProtocol, router: GameSettingsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoaded() {
        //
    }
    
    func processStartButton(for game: Int) {
        router.navigateToPlaying(for: game)
    }
    
    func processBackButton() {
        router.navigateBack()
    }

}
