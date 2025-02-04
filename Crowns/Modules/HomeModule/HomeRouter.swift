//
//  Router.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    func navigateToLearning(for game: Int)
    func navigateToPlaySettings(for game: Int)
}

class HomeRouter: HomeRouterProtocol {
    weak var presenter: HomePresenterProtocol?
    weak var viewController: UIViewController?
    
    
    func navigateToLearning(for game: Int) {
        if game == Numbers.crownsTag {
            viewController?.navigationController?.pushViewController(CrownsLearningModuleBuilder.build(), animated: false)
        } else if game == Numbers.sudokuTag {
            viewController?.navigationController?.pushViewController(SudokuLearningModuleBuilder.build(), animated: false)
        } else {
            viewController?.navigationController?.pushViewController(QueensLearningModuleBuilder.build(), animated: false)
        }
    }
    
    func navigateToPlaySettings(for game: Int) {
        viewController?.navigationController?.pushViewController(GameSettingsModuleBuilder.build(for: game), animated: false)
    }
}
