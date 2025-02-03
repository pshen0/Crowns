//
//  SettimgUpGamePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol SettingUpGamePresenterProtocol: AnyObject {
    func viewDidLoaded()
    func startButtonTapped(for game: String)
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
    
    func startButtonTapped(for game: String) {
        router.navigateToPlaying(for: game)
    }

}
