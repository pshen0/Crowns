//
//  SudokuPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SudokuPlayRouterProtocol: AnyObject {
}

class SudokuPlayRouter:SudokuPlayRouterProtocol {
    weak var presenter: SudokuPlayPresenterProtocol?
    weak var viewController: UIViewController?
}
