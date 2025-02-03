//
//  ProfileRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

protocol ProfileRouterProtocol: AnyObject {
}

class ProfileRouter: ProfileRouterProtocol {
    weak var presenter: ProfilePresenterProtocol?
    weak var viewController: UIViewController?
}
