//
//  SudokuLearningModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class SudokuLearningModuleBuilder {
    static func build() -> SudokuLearningViewController {
        let interactor = SudokuLearningInteractor()
        let router = SudokuLearningRouter()
        let presenter = SudokuLearningPresenter(interactor: interactor, router: router)
        let viewController = SudokuLearningViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
