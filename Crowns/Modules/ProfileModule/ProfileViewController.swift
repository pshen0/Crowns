//
//  ProfileViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    
}

final class ProfileViewController: UIViewController, ProfileViewProtocol{
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        configureUI()
    }
    
    private func configureUI() {
        configureBackground()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
    }
}
