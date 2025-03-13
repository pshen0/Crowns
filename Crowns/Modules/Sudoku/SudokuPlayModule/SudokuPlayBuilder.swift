//
//  SudokuPlayModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

import UIKit

enum SudokuPlayBuilder {
    static func build(_ foundation: SudokuPlayModel.BuildModule.BuildFoundation) -> SudokuPlayViewController {
        let killerSudoku = KillerSudoku(difficultyLeve: foundation.difficultyLevel)
        let presenter = SudokuPlayPresenter()
        let interactor = SudokuPlayInteractor(presenter: presenter, killerSudoku: killerSudoku)
        let view = SudokuPlayViewController(interactor: interactor)
        presenter.view = view
        return view
    }
}
