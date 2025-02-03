//
//  ChallengeRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

protocol ChallengeRouterProtocol: AnyObject {
}

class ChallengeRouter: ChallengeRouterProtocol {
    weak var presenter: ChallengePresenterProtocol?
    weak var viewController: UIViewController?
}
