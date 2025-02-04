//
//  SettimgUpGameModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class SettingUpGameModuleBuilder {
    static func build(for game: Int) -> SettingUpGameViewController {
        let interactor = SettingUpGameInteractor()
        let router = SettingUpGameRouter()
        let presenter = SettingUpGamePresenter(interactor: interactor, router: router)
        let viewController = SettingUpGameViewController(for: game)
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
