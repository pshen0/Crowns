//
//  SettimgUpGameModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class GameSettingsModuleBuilder {
    static func build(for game: Int) -> GameSettingsViewController {
        let interactor = GameSettingsInteractor()
        let router = GameSettingsRouter()
        let presenter = GameSettingsPresenter(interactor: interactor, router: router)
        let viewController = GameSettingsViewController(for: game)
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
