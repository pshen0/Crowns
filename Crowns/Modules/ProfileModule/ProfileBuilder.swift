//
//  ProfileModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit


enum ProfileBuilder {
    static func build() -> ProfileViewController {
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(presenter: presenter)
        let view = ProfileViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
