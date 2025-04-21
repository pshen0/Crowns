//
//  GameOverViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.04.2025.
//

import UIKit

final class CrownsGameOverViewController: UIViewController {
    
    private let interactor: CrownsGameOverBusinessLogic
    private let gameLogo: UILabel = CustomText(text: Text.crownsGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    private var gameResult: UILabel = UILabel()
    private var gameTime: UILabel = UILabel()
    private var catImage: UIImageView = UIImageView()
    private let homeButton: UIButton = CustomButton(button: UIImageView(image: Images.gameOverHomeButton))
    private let statisticsButton: UIButton = CustomButton(button: UIImageView(image: Images.statisticsButton))
    
    init(interactor: CrownsGameOverBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        let result = interactor.isWin(CrownsGameOverModel.IsWin.Request())
        gameResult = CustomText(text: result.0, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
        let timerLabel = interactor.timerLabel(CrownsGameOverModel.getTime.Request())
        gameTime = CustomText(text: "Elapsed time: \(timerLabel)", fontSize: 20, textColor: Colors.white)
        catImage = UIImageView(image: result.1)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureBackground()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        
        for subview in [gameLogo, gameResult, gameTime, catImage, homeButton, statisticsButton] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        gameResult.pinTop(to: gameLogo.bottomAnchor, 20)
        gameTime.pinTop(to: gameResult.bottomAnchor, 20)
        catImage.pinTop(to: gameTime.bottomAnchor, 50)
        homeButton.pinTop(to: catImage.bottomAnchor, 50)
        statisticsButton.pinTop(to: homeButton.bottomAnchor, 10)
        
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        statisticsButton.addTarget(self, action: #selector(statisticsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func homeButtonTapped() {
        interactor.homeButtonTapped(CrownsGameOverModel.RouteHome.Request())
    }
    
    @objc private func statisticsButtonTapped() {
        interactor.statisticsButtonTapped(CrownsGameOverModel.RouteStatistics.Request())
    }
}

