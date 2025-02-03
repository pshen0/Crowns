//
//  SudokuPlayModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

class SudokuPlayModuleBuilder {
    static func build() -> SudokuPlayViewController {
        let interactor = SudokuPlayInteractor()
        let router = SudokuPlayRouter()
        let presenter = SudokuPlayPresenter(interactor: interactor, router: router)
        let viewController = SudokuPlayViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
