//
//  SettimgUpGamePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol SettingUpGamePresenterProtocol: AnyObject {
    func viewDidLoaded()
    func processStartButton(for game: Int)
    func processBackButton()
}

class SettingUpGamePresenter: SettingUpGamePresenterProtocol {
    weak var view: SettingUpGameViewProtocol?
    var router: SettingUpGameRouterProtocol
    var interactor: SettingUpGameInteractorProtocol
    
    init(interactor: SettingUpGameInteractorProtocol, router: SettingUpGameRouterProtocol) {
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
