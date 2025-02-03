//
//  QueensPlayModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class QueensPlayModuleBuilder {
    static func build() -> QueensPlayViewController {
        let interactor = QueensPlayInteractor()
        let router = QueensPlayRouter()
        let presenter = QueensPlayPresenter(interactor: interactor, router: router)
        let viewController = QueensPlayViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
