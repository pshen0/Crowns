//
//  SettimgUpGameRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol GameSettingsRouterProtocol: AnyObject {
    func navigateToPlaying (for game: Int)
    func navigateBack()
}

class GameSettingsRouter: GameSettingsRouterProtocol {
    weak var presenter: GameSettingsPresenterProtocol?
    weak var viewController: UIViewController?
    
    func navigateToPlaying (for game: Int) {
        if game == Numbers.crownsTag {
            viewController?.navigationController?.pushViewController(CrownsPlayModuleBuilder.build(), animated: false)
        } else if game == Numbers.sudokuTag {
            viewController?.navigationController?.pushViewController(SudokuPlayModuleBuilder.build(), animated: false)
        } else {
            viewController?.navigationController?.pushViewController(QueensPlayModuleBuilder.build(), animated: false)
        }
    }
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: false)
    }
}
