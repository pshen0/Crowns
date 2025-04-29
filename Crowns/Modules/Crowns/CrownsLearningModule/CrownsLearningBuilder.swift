//
//  CrownsLearningModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

// MARK: - CrownsLearningBuilder
enum CrownsLearningBuilder {
    static func build() -> CrownsLearningViewController {
        let presenter = CrownsLearningPresenter()
        let interactor = CrownsLearningInteractor(presenter: presenter)
        let view = CrownsLearningViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
