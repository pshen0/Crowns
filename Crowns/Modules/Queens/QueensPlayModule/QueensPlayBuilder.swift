//
//  QueensPlayModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

enum QueensPlayBuilder {
    static func build() -> QueensPlayViewController {
        let presenter = QueensPlayPresenter()
        let interactor = QueensPlayInteractor(presenter: presenter)
        let view = QueensPlayViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
