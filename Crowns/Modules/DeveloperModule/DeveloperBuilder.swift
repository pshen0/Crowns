//
//  DeveloperBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import UIKit

// MARK: - DeveloperBuilder
enum DeveloperBuilder {
    static func build() -> DeveloperViewController {
        let presenter = DeveloperPresenter()
        let interactor = DeveloperInteractor(presenter: presenter)
        let view = DeveloperViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
