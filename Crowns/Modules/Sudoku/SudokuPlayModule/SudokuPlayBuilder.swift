//
//  SudokuPlayModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

import UIKit

enum SudokuPlayBuilder {
    static func build() -> SudokuPlayViewController {
        let presenter = SudokuPlayPresenter()
        let interactor = SudokuPlayInteractor(presenter: presenter)
        let view = SudokuPlayViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
