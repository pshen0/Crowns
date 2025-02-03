//
//  CrownsPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol CrownsPlayRouterProtocol: AnyObject {
}

class CrownsPlayRouter: CrownsPlayRouterProtocol {
    weak var presenter: CrownsPlayPresenterProtocol?
    weak var viewController: UIViewController?
}

