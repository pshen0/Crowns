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
    private let gameSelectorViewController = GameSelector()
    private let newGameButton: UIButton = CustomButton(button: UIImageView(image: Images.newGameButton))
    private let continueButton: UIButton = CustomButton(button: UIImageView(image: Images.continueButton))
    private let learningButton: UIButton = CustomButton(button: UIImageView(image: Images.learningButton))
    private let homeLogoPicture = UIImageView(image: Images.homeLogoPicture)
    private let homeLogoText = CustomText(text: Text.homeLogo, fontSize: Constraints.homeLogoSize, textColor: Colors.white)
    private let homeCalendar = UIImageView(image: Images.homeCalendar)
    private var homeButtons: Array<UIButton> = []
    private var selectorButtons: Array<UIButton> = []
    
    init(interactor: HomeBusinessLogic) {
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
        gameSelectorViewController.modalPresentationStyle = .overFullScreen
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
        homeLogoText.pinTop(to: homeLogoPicture.bottomAnchor, Constraints.homeLogoTextTop)
    }
    
    private func configureCalendar() {
        view.addSubview(homeCalendar)
        
        homeCalendar.pinCenterX(to: view)
        homeCalendar.pinTop(to: homeLogoText.bottomAnchor, Constraints.homeCalendarTop)
    }
    
    private func configureButtons() {
        homeButtons = [newGameButton, continueButton, learningButton]
        selectorButtons = [gameSelectorViewController.chooseCrownsButton, 
                           gameSelectorViewController.chooseSudokuButton,
                           gameSelectorViewController.chooseQueensButton]
        for button in homeButtons {
            view.addSubview(button)
            button.pinCenterX(to: view)
        }
        
        newGameButton.pinTop(to: homeCalendar.bottomAnchor, Constraints.newGameButtonTop)
        continueButton.pinTop(to: newGameButton.bottomAnchor, Constraints.continueButtonTop)
        learningButton.pinTop(to: continueButton.bottomAnchor, Constraints.learningButtonTop)
        
        newGameButton.addTarget(self, action: #selector(gameSelectorTapped), for: .touchUpInside)
        learningButton.addTarget(self, action: #selector(learningSelectorTapped), for: .touchUpInside)
    }
    
    func hideGameSelector() {
        gameSelectorViewController.dismiss(animated: false)
        for button in selectorButtons {
            button.removeTarget(nil, action: nil, for: .allEvents)
        }
        gameSelectorViewController.chooseGameText.isHidden = true
        gameSelectorViewController.chooseLearningText.isHidden = true
    }
    
    @objc private func gameSelectorTapped() {
        self.present(gameSelectorViewController, animated: false)
        gameSelectorViewController.chooseGameText.isHidden = false
        gameSelectorViewController.chooseCrownsButton.addTarget(self, action: #selector(self.playCrownsTapped), for: .touchUpInside)
        gameSelectorViewController.chooseSudokuButton.addTarget(self, action: #selector(self.playSudokuTapped), for: .touchUpInside)
        gameSelectorViewController.chooseQueensButton.addTarget(self, action: #selector(self.playQueensTapped), for: .touchUpInside)
    }
    
    @objc private func learningSelectorTapped() {
        self.present(gameSelectorViewController, animated: false)
        gameSelectorViewController.chooseLearningText.isHidden = false
        gameSelectorViewController.chooseCrownsButton.addTarget(self, action: #selector(self.learnCrownsTapped), for: .touchUpInside)
        gameSelectorViewController.chooseSudokuButton.addTarget(self, action: #selector(self.learnSudokuTapped), for: .touchUpInside)
        gameSelectorViewController.chooseQueensButton.addTarget(self, action: #selector(self.learnQueensTapped), for: .touchUpInside)
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
