//
//  CrownsPlayModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class CrownsPlayModuleBuilder {
    static func build() -> CrownsPlayViewController {
        let interactor = CrownsPlayInteractor()
        let router = CrownsPlayRouter()
        let presenter = CrownsPlayPresenter(interactor: interactor, router: router)
        let viewController = CrownsPlayViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
