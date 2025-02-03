//
//  Router.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    func navigateToLearning(for game: String)
    func navigateToPlaySettings(for game: String)
}

class HomeRouter: HomeRouterProtocol {
    weak var presenter: HomePresenterProtocol?
    weak var viewController: UIViewController?
    
    
    func navigateToLearning(for game: String) {
        if game == Numbers.crownsTag {
            viewController?.navigationController?.pushViewController(CrownsLearningViewController(), animated: false)
        } else if game == Numbers.sudokuTag {
            viewController?.navigationController?.pushViewController(SudokuLearningViewController(), animated: false)
        } else {
            viewController?.navigationController?.pushViewController(QueensLearningViewController(), animated: false)
        }
    }
    
    func navigateToPlaySettings(for game: String) {
        viewController?.navigationController?.pushViewController(SettingUpGameModuleBuilder.build(for: game), animated: false)
    }
}
