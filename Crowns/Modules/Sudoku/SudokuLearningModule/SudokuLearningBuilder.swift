//
//  SudokuLearningModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

// MARK: - SudokuLearningBuilder
enum SudokuLearningBuilder {
    static func build() -> SudokuLearningViewController {
        let presenter = SudokuLearningPresenter()
        let interactor = SudokuLearningInteractor(presenter: presenter)
        let view = SudokuLearningViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
