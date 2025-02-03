//
//  ProfileModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

class ProfileModuleBuilder {
    static func build() -> ProfileViewController {
        let interactor = ProfileInteractor()
        let router = ProfileRouter()
        let presenter = ProfilePresenter(interactor: interactor, router: router)
        let viewController = ProfileViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
