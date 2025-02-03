//
//  ChallengeModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

class ChallengeModuleBuilder {
    static func build() -> ChallengeViewController {
        let interactor = ChallengeInteractor()
        let router = ChallengeRouter()
        let presenter = ChallengePresenter(interactor: interactor, router: router)
        let viewController = ChallengeViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
