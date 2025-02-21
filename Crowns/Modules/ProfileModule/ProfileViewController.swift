//
//  ProfileViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController{
    private let interactor: ProfileBusinessLogic
    
    init(interactor: ProfileBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureBackground()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
    }
}
