//
//  QueensPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol QueensPlayRouterProtocol: AnyObject {
}

class QueensPlayRouter: QueensPlayRouterProtocol {
    weak var presenter: QueensPlayPresenterProtocol?
    weak var viewController: UIViewController?
}
