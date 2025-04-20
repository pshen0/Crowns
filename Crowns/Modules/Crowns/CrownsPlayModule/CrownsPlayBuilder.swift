//
//  CrownsPlayModuleBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

enum CrownsPlayBuilder {
    static func build(_ foundation: CrownsPlayModel.BuildModule.BuildFoundation) -> CrownsPlayViewController {
        let presenter = CrownsPlayPresenter()
        let interactor = CrownsPlayInteractor(presenter: presenter, foundation: foundation)
        let view = CrownsPlayViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
