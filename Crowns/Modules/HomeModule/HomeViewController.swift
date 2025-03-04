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
    private let chooseGameText = CustomText(text: Text.chooseGame, fontSize: Constraints.selectorTextSize, textColor: Colors.white)
    private let chooseLearningText = CustomText(text: Text.chooseLearning, fontSize: Constraints.selectorTextSize, textColor: Colors.white)
    private let newGameButton: UIButton = CustomButton(button: UIImageView(image: Images.newGameButton))
    private let continueButton: UIButton = CustomButton(button: UIImageView(image: Images.continueButton))
    private let learningButton: UIButton = CustomButton(button: UIImageView(image: Images.learningButton))
    private let homeLogoPicture = UIImageView(image: Images.homeLogoPicture)
    private let homeLogoText = CustomText(text: Text.homeLogo, fontSize: Constraints.homeLogoSize, textColor: Colors.white)
    private let homeCalendar = CustomCalendar()
    private let homeButtonsStack: UIStackView = UIStackView()
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
        fatalError(Text.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        gameSelectorViewController.modalPresentationStyle = .overFullScreen
        learningSelectorViewController.modalPresentationStyle = .overFullScreen
        configureBackground()
        configureCalendar()
        configureButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        view.addSubview(homeLogoPicture)
        view.addSubview(homeLogoText)
        
        homeLogoPicture.pinCenterX(to: view)
        homeLogoPicture.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.homeLogoPictureTop)
        homeLogoText.pinCenterX(to: view)
        homeLogoText.setWidth(Constraints.homeLogoTextWidth)
        homeLogoText.pinTop(to: homeLogoPicture.bottomAnchor, Constraints.homeLogoTextTop)
    }
    
    private func configureCalendar() {
        view.addSubview(homeCalendar)
        
        homeCalendar.setWidth(Constraints.homeCalendarWidth)
        homeCalendar.setHeight(Constraints.homeCalendarHeight)
        homeCalendar.pinCenterX(to: view)
        homeCalendar.pinTop(to: homeLogoText.bottomAnchor, Constraints.homeCalendarTop)
    }
    
    private func configureButtons() {
        homeButtonsStack.axis = .vertical
        homeButtonsStack.alignment = .center
        homeButtonsStack.spacing = Constraints.homeButtonStackSpacing
        
        for button in [newGameButton, continueButton, learningButton] {
            homeButtonsStack.addArrangedSubview(button)
        }
        
        view.addSubview(homeButtonsStack)
        
        homeButtonsStack.pinCenterX(to: view)
        homeButtonsStack.pinTop(to: homeCalendar.bottomAnchor, Constraints.homeButtonStackTop)
        
        newGameButton.addTarget(self, action: #selector(gameSelectorTapped), for: .touchUpInside)
        learningButton.addTarget(self, action: #selector(learningSelectorTapped), for: .touchUpInside)
        
        gameSelectorViewController.chooseCrownsButton.addTarget(self, action: #selector(playCrownsTapped), for: .touchUpInside)
        gameSelectorViewController.chooseSudokuButton.addTarget(self, action: #selector(playSudokuTapped), for: .touchUpInside)
        gameSelectorViewController.chooseQueensButton.addTarget(self, action: #selector(playQueensTapped), for: .touchUpInside)
        learningSelectorViewController.chooseCrownsButton.addTarget(self, action: #selector(learnCrownsTapped), for: .touchUpInside)
        learningSelectorViewController.chooseSudokuButton.addTarget(self, action: #selector(learnSudokuTapped), for: .touchUpInside)
        learningSelectorViewController.chooseQueensButton.addTarget(self, action: #selector(learnQueensTapped), for: .touchUpInside)
    }
    
    func hideGameSelector() {
        gameSelectorViewController.dismiss(animated: false)
    }
    
    func hideLearningSelector() {
        learningSelectorViewController.dismiss(animated: false)
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
    
    @objc private func playQueensTapped() {
        interactor.playQueensTapped(HomeModel.RouteToQueensSettings.Request())
    }
    
    @objc private func learnCrownsTapped() {
        interactor.learnCrownsTapped(HomeModel.RouteToCrownsLearning.Request())
    }
    
    @objc private func learnSudokuTapped() {
        interactor.learnSudokuTapped(HomeModel.RouteToSudokuLearning.Request())
    }
    
    @objc private func learnQueensTapped() {
        interactor.learnQueensTapped(HomeModel.RouteToQueensLearning.Request())
    }
}
