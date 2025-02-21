//
//  QueensSettingsBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import UIKit

enum QueensSettingsBuilder {
    static func build() -> QueensSettingsViewController {
        let presenter = QueensSettingsPresenter()
        let interactor = QueensSettingsInteractor(presenter: presenter)
        let view = QueensSettingsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
