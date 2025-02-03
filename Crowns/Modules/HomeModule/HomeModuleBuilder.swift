//
//  HomeModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

class HomeModuleBuilder {
    static func build() -> HomeViewController {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let viewController = HomeViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
