//
//  SudokuSettingsBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation


import UIKit

enum SudokuSettingsBuilder {
    static func build() -> SudokuSettingsViewController {
        let presenter = SudokuSettingsPresenter()
        let interactor = SudokuSettingsInteractor(presenter: presenter)
        let view = SudokuSettingsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
