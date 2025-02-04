//
//  QueensPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol QueensPlayRouterProtocol: AnyObject {
    func navigateBack()
}

class QueensPlayRouter: QueensPlayRouterProtocol {
    weak var presenter: QueensPlayPresenterProtocol?
    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: false)
    }
}
