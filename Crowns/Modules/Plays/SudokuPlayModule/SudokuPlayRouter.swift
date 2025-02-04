//
//  SudokuPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SudokuPlayRouterProtocol: AnyObject {
    func navigateBack()
}

class SudokuPlayRouter:SudokuPlayRouterProtocol {
    weak var presenter: SudokuPlayPresenterProtocol?
    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: false)
    }
}
