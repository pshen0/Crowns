//
//  ChallengeBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

enum ChallengeBuilder {
    static func build() -> ChallengeViewController {
        let presenter = ChallengePresenter()
        let interactor = ChallengeInteractor(presenter: presenter)
        let view = ChallengeViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
