//
//  CrownsLearningModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class CrownsLearningModuleBuilder {
    static func build() -> CrownsLearningViewController {
        let interactor = CrownsLearningInteractor()
        let router = CrownsLearningRouter()
        let presenter = CrownsLearningPresenter(interactor: interactor, router: router)
        let viewController = CrownsLearningViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
