//
//  SudokuLearningRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SudokuLearningRouterProtocol: AnyObject {
    func navigateBack()
}

class SudokuLearningRouter: SudokuLearningRouterProtocol {
    weak var presenter: SudokuLearningPresenterProtocol?
    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: false)
    }
}
