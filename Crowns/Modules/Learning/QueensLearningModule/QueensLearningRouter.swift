//
//  QueensLearningRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol QueensLearningRouterProtocol: AnyObject {
    func navigateBack()
}

class QueensLearningRouter: QueensLearningRouterProtocol {
    weak var presenter: QueensLearningPresenterProtocol?
    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: false)
    }
}
