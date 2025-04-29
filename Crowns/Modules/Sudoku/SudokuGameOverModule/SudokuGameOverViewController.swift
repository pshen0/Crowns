//
//  SudokuGameOverViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import UIKit

// MARK: - SudokuGameOverViewController class
final class SudokuGameOverViewController: UIViewController {
    
    // MARK: - Properties
    private let interactor: SudokuGameOverBusinessLogic
    private let logo: UILabel = CustomText(text: Constants.logoText, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private var result: UILabel = UILabel()
    private var time: UILabel = UILabel()
    private var catImage: UIImageView = UIImageView()
    private let homeButton: UIButton = CustomButton(button: UIImageView(image: UIImage.gameOverHomeButton))
    private let statisticsButton: UIButton = CustomButton(button: UIImageView(image: UIImage.statisticsButton))
    
    // MARK: - Lifecycle
    init(interactor: SudokuGameOverBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        let result = interactor.isWin(SudokuGameOverModel.IsWin.Request())
        self.result = CustomText(text: result.0, fontSize: Constants.logoTextSize, textColor: Colors.white)
        let timerLabel = interactor.timerLabel(SudokuGameOverModel.getTime.Request())
        time = CustomText(text: "\(Constants.gameTimeText) \(timerLabel)", fontSize: Constants.gameTimeTextSize, textColor: Colors.white)
        catImage = UIImageView(image: result.1)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Errors.initErrorCoder)
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
    
    // MARK: - Private funcs
    private func configureUI() {
        configureBackground()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        
        for subview in [logo, result, time, catImage, homeButton, statisticsButton] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        result.pinTop(to: logo.bottomAnchor, Constants.gameResultTop)
        time.pinTop(to: result.bottomAnchor, Constants.gameTimeTop)
        catImage.pinTop(to: time.bottomAnchor, Constants.catImageTop)
        homeButton.pinTop(to: catImage.bottomAnchor, Constants.homeButtonTop)
        statisticsButton.pinTop(to: homeButton.bottomAnchor, Constants.statisticsButtonTop)
        
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        statisticsButton.addTarget(self, action: #selector(statisticsButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func homeButtonTapped() {
        interactor.homeButtonTapped(SudokuGameOverModel.RouteHome.Request())
    }
    
    @objc private func statisticsButtonTapped() {
        interactor.statisticsButtonTapped(SudokuGameOverModel.RouteStatistics.Request())
    }
    
    // MARK: - Constants
    private enum Constants {
        static let logoText = "Sudoku"
        static let gameTimeText = "Elapsed time:"
        
        static let gameResultTop = 20.0
        static let gameTimeTop = 20.0
        static let catImageTop = 50.0
        static let homeButtonTop = 50.0
        static let statisticsButtonTop = 10.0
        
        static let logoTextSize: CGFloat = 34
        static let gameTimeTextSize: CGFloat = 20
    }
}

