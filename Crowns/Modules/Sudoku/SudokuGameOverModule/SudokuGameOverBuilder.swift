//
//  SudokuGameOverBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import Foundation

import UIKit

enum SudokuGameOverBuilder {
    static func build() -> SudokuGameOverViewController {
        let presenter = SudokuGameOverPresenter()
        let interactor = SudokuGameOverInteractor(presenter: presenter)
        let view = SudokuGameOverViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
