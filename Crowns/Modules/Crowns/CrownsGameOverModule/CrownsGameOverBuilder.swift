//
//  CrownsGameOverBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import Foundation

import UIKit

enum CrownsGameOverBuilder {
    static func build(isWin: Bool, time: String) -> CrownsGameOverViewController {
        let presenter = CrownsGameOverPresenter()
        let interactor = CrownsGameOverInteractor(presenter: presenter, isWin: isWin, time: time)
        let view = CrownsGameOverViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}

