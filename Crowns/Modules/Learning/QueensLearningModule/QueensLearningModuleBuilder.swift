//
//  QueensLearningModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class QueensLearningModuleBuilder {
    static func build() -> QueensLearningViewController {
        let interactor = QueensLearningInteractor()
        let router = QueensLearningRouter()
        let presenter = QueensLearningPresenter(interactor: interactor, router: router)
        let viewController = QueensLearningViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
