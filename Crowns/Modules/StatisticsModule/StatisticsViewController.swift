//
//  StatisticsViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let interactor: StatisticsBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    
    lazy var barButtonItem = UIBarButtonItem()
    
    init(interactor: StatisticsBusinessLogic) {
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
        barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(StatisticsModel.RouteBack.Request())
    }
}
