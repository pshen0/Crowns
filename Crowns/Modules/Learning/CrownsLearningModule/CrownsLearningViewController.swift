//
//  CrownsLearningViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 02.02.2025.
//

import UIKit



final class CrownsLearningViewController: UIViewController{
    
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                      tapped: UIImageView(image: Images.backButtonTap))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureUI() {
        configureBackground()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
    
}
