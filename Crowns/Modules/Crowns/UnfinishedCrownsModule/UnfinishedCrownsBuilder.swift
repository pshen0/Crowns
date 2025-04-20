//
//  UnfinishedCrownsBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

import UIKit

enum UnfinishedCrownsBuilder {
    static func build(foundation: UnfinishedCrownsModel.BuildModule.BuildFoundation) -> UnfinishedCrownsViewController {
        let presenter = UnfinishedCrownsPresenter()
        let interactor = UnfinishedCrownsInteractor(presenter: presenter, foundation: foundation)
        let view = UnfinishedCrownsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
