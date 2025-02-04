//
//  CrownsLearningRoter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol CrownsLearningRouterProtocol: AnyObject {
    func navigateBack()
}

class CrownsLearningRouter: CrownsLearningRouterProtocol {
    weak var presenter: CrownsLearningPresenterProtocol?
    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: false)
    }
}

