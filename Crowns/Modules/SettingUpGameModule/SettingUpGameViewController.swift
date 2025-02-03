//
//  SettingUpGameViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 02.02.2025.
//

import UIKit

protocol SettingUpGameViewProtocol: AnyObject {
    
}


final class SettingUpGameViewController: UIViewController, SettingUpGameViewProtocol{
    
    private let gameLogoCrowns = UIImageView(image: Images.gameLogoCrowns)
    private let gameLogoSudoku = UIImageView(image: Images.gameLogoSudoku)
    private let gameLogoQueens = UIImageView(image: Images.gameLogoQueens)
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                      tapped: UIImageView(image: Images.backButtonTap))
    private let startPlayButton: UIButton = CustomButton(button: UIImageView(image: Images.startPlayButton),
                                                         tapped: UIImageView(image: Images.startPlayButtonTap))
    
    var presenter: SettingUpGamePresenterProtocol?
    lazy var game: String = ""
    
    init(for game: String) {
        super.init(nibName: nil, bundle: nil)
        self.game = game
        if game == Numbers.crownsTag {
            configureCrownsSettings()
        } else if game == Numbers.sudokuTag {
            configureSudokuSettings()
        } else {
            configureQueensSettings()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
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
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        
        view.addSubview(startPlayButton)
        NSLayoutConstraint.activate([
            startPlayButton.pinCenterX(to: view),
            startPlayButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 30)
        ])
        startPlayButton.addTarget(self, action: #selector(startPlayButtonTapped), for: .touchUpInside)
    }
    
    private func configureCrownsSettings () {
        view.addSubview(gameLogoCrowns)
        
        NSLayoutConstraint.activate([
            gameLogoCrowns.pinCenterX(to: view),
            gameLogoCrowns.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Numbers.gameLogoTop)
        ])
    }
    
    private func configureSudokuSettings () {
        view.addSubview(gameLogoSudoku)
        
        NSLayoutConstraint.activate([
            gameLogoSudoku.pinCenterX(to: view),
            gameLogoSudoku.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Numbers.gameLogoTop)
        ])
    }
    
    private func configureQueensSettings () {
        view.addSubview(gameLogoQueens)
        NSLayoutConstraint.activate([
            gameLogoQueens.pinCenterX(to: view),
            gameLogoQueens.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Numbers.gameLogoTop)
        ])
    }
    
    
    @objc private func backButtonTapped() {        
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func startPlayButtonTapped() {
        presenter?.startButtonTapped(for: game)
    }
}
