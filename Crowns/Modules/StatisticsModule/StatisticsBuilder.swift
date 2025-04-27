//
//  StatisticsBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import UIKit

enum StatisticsBuilder {
    static func build(game: StatisticsModel.GameType) -> StatisticsViewController {
        let presenter = StatisticsPresenter()
        let interactor = StatisticsInteractor(presenter: presenter, game: game)
        let view = StatisticsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
