//
//  HomeModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

// MARK: - HomeBuilder enum
enum HomeBuilder {
    static func build() -> HomeViewController {
        let presenter = HomePresenter()
        let interactor = HomeInteractor(presenter: presenter)
        let view = HomeViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
