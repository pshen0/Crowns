//
//  ViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

import UIKit

final class HomeViewController: UIViewController{
    
    private let interactor: HomeBusinessLogic
    private let overlayView = UIView()
    private let chooseGameText = CustomText(text: Constants.chooseGame, fontSize: Constants.selectorTextSize, textColor: Colors.white)
    private let chooseLearningText = CustomText(text: Constants.chooseLearning, fontSize: Constants.selectorTextSize, textColor: Colors.white)
    private let newGameButton: UIButton = CustomButton(button: UIImageView(image: UIImage.newGameButton))
    private let learningButton: UIButton = CustomButton(button: UIImageView(image: UIImage.learningButton))
    private let logoPicture = UIImageView(image: UIImage.homeLogoPicture)
    private let logoText = CustomText(text: Constants.logo, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let calendar = CustomCalendar()
    private let buttonsStack: UIStackView = UIStackView()
    private var selectorButtons: Array<UIButton> = []
    private var gameSelectorViewController = GameSelector()
    private var learningSelectorViewController = GameSelector()
    
    init(interactor: HomeBusinessLogic) {
        self.interactor = interactor
        self.gameSelectorViewController = GameSelector(logo: chooseGameText)
        self.learningSelectorViewController = GameSelector(logo: chooseLearningText)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Errors.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.updateMarkedDates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.unfinishedCrownsGame) {
            interactor.getUnfinishedCrownsGame(HomeModel.GetUnfinishedCrownsGame.Request())
        } else if UserDefaults.standard.bool(forKey: UserDefaultsKeys.unfinishedSudokuGame) {
            interactor.getUnfinishedSudokuGame(HomeModel.GetUnfinishedSudokuGame.Request())
        }
    }
    
    private func configureUI() {
        gameSelectorViewController.modalPresentationStyle = .overFullScreen
        learningSelectorViewController.modalPresentationStyle = .overFullScreen
        configureBackground()
        configureCalendar()
        calendar.updateMarkedDates()
        configureButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        view.addSubview(logoPicture)
        view.addSubview(logoText)
        
        logoPicture.pinCenterX(to: view)
        logoPicture.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.logoPictureTop)
        logoText.pinCenterX(to: view)
        logoText.setWidth(Constants.logoTextWidth)
        logoText.pinTop(to: logoPicture.bottomAnchor, Constants.logoTextTop)
    }
    
    private func configureCalendar() {
        view.addSubview(calendar)
        
        calendar.setWidth(Constants.calendarWidth)
        calendar.setHeight(Constants.calendarHeight)
        calendar.pinCenterX(to: view)
        calendar.pinTop(to: logoText.bottomAnchor, Constants.calendarTop)
    }
    
    private func configureButtons() {
        buttonsStack.axis = .vertical
        buttonsStack.alignment = .center
        buttonsStack.spacing = Constants.buttonStackSpacing
        
        for button in [newGameButton, learningButton] {
            buttonsStack.addArrangedSubview(button)
        }
        
        view.addSubview(buttonsStack)
        
        buttonsStack.pinCenterX(to: view)
        buttonsStack.pinTop(to: calendar.bottomAnchor, Constants.buttonStackTop)
        
        newGameButton.addTarget(self, action: #selector(gameSelectorTapped), for: .touchUpInside)
        learningButton.addTarget(self, action: #selector(learningSelectorTapped), for: .touchUpInside)
        
        gameSelectorViewController.chooseCrownsButton.addTarget(self, action: #selector(playCrownsTapped), for: .touchUpInside)
        gameSelectorViewController.chooseSudokuButton.addTarget(self, action: #selector(playSudokuTapped), for: .touchUpInside)
        learningSelectorViewController.chooseCrownsButton.addTarget(self, action: #selector(learnCrownsTapped), for: .touchUpInside)
        learningSelectorViewController.chooseSudokuButton.addTarget(self, action: #selector(learnSudokuTapped), for: .touchUpInside)
    }
    
    func hideGameSelector() {
        gameSelectorViewController.dismiss(animated: false)
    }
    
    func hideLearningSelector() {
        learningSelectorViewController.dismiss(animated: false)
    }
    
    func showUnfinishedCrowns(_ viewModel: UnfinishedCrownsModel.BuildModule.BuildFoundation) {
        let unfinishedGameView = UnfinishedCrownsBuilder.build(foundation: viewModel)
        unfinishedGameView.modalPresentationStyle = .overFullScreen
        unfinishedGameView.delegate = self
        self.present(unfinishedGameView, animated: false)
    }
    
    func showUnfinishedSudoku(_ viewModel: UnfinishedSudokuModel.BuildModule.BuildFoundation) {
        let unfinishedGameView = UnfinishedSudokuBuilder.build(foundation: viewModel)
        unfinishedGameView.modalPresentationStyle = .overFullScreen
        unfinishedGameView.delegate = self
        self.present(unfinishedGameView, animated: false)
    }
    
    @objc private func gameSelectorTapped() {
        self.present(gameSelectorViewController, animated: false)
    }
    
    @objc private func learningSelectorTapped() {
        self.present(learningSelectorViewController, animated: false)
    }
    
    @objc private func playCrownsTapped() {
        interactor.playCrownsTapped(HomeModel.RouteToCrownsSettings.Request())
    }
    
    @objc private func playSudokuTapped() {
        interactor.playSudokuTapped(HomeModel.RouteToSudokuSettings.Request())
    }
    
    @objc private func learnCrownsTapped() {
        interactor.learnCrownsTapped(HomeModel.RouteToCrownsLearning.Request())
    }
    
    @objc private func learnSudokuTapped() {
        interactor.learnSudokuTapped(HomeModel.RouteToSudokuLearning.Request())
    }
}

extension HomeViewController: UnfinishedCrownsViewControllerDelegate,  UnfinishedSudokuViewControllerDelegate {
    func unfinishedSudokuDidRequestToContinue(with foundation: SudokuPlayModel.BuildModule.BuildFoundation) {
        navigationController?.pushViewController(SudokuPlayBuilder.build(foundation) , animated: true)
    }
    
    func unfinishedCrownsDidRequestToContinue(with foundation: CrownsPlayModel.BuildModule.BuildFoundation) {
        navigationController?.pushViewController(CrownsPlayBuilder.build(foundation) , animated: true)
    }
    
    private enum Constants {
        static let chooseGame: String = "Choose game:"
        static let chooseLearning: String = "Choose learning:"
        static let logo: String = "CROWNS"
        
        static let selectorTextSize: CGFloat = 25
        static let logoTextSize: CGFloat = 75
        static let logoTextWidth: CGFloat = 350
        static let calendarWidth: CGFloat = 350
        static let calendarHeight: CGFloat = 250
        
        static let logoPictureTop: CGFloat = 0
        static let logoTextTop: CGFloat = 5
        static let calendarTop: CGFloat = 35
        static let buttonStackSpacing: CGFloat = 8
        static let buttonStackTop: CGFloat = 30
    }
}



