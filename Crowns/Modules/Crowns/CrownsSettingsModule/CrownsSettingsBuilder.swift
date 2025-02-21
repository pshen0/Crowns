//
//  CrownsSettingsBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import UIKit

enum CrownsSettingsBuilder {
    static func build() -> CrownsSettingsViewController {
        let presenter = CrownsSettingsPresenter()
        let interactor = CrownsSettingsInteractor(presenter: presenter)
        let view = CrownsSettingsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
