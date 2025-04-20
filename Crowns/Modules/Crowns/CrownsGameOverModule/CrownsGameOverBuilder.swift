//
//  CrownsGameOverBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation

import UIKit

enum CrownsGameOverBuilder {
    static func build(isWin: String) -> CrownsGameOverViewController {
        let presenter = CrownsGameOverPresenter()
        let interactor = CrownsGameOverInteractor(presenter: presenter, isWin)
        let view = CrownsGameOverViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}

