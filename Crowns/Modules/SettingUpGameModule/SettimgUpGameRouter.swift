//
//  SettimgUpGameRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SettingUpGameRouterProtocol: AnyObject {
    func navigateToPlaying (for game: String)
}

class SettingUpGameRouter: SettingUpGameRouterProtocol {
    weak var presenter: SettingUpGamePresenterProtocol?
    weak var viewController: UIViewController?
    
    func navigateToPlaying (for game: String) {
        if game == Numbers.crownsTag {
            viewController?.navigationController?.pushViewController(CrownsPlayModuleBuilder.build(), animated: false)
        } else if game == Numbers.sudokuTag {
            viewController?.navigationController?.pushViewController(SudokuPlayModuleBuilder.build(), animated: false)
        } else {
            viewController?.navigationController?.pushViewController(QueensPlayModuleBuilder.build(), animated: false)
        }
    }
}
