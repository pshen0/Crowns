//
//  ViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    
}

final class HomeViewController: UIViewController, HomeViewProtocol{
    
    private let overlayView = UIView()
    private let gameSelectorView = UIView()
    private let newGameButton: UIButton = CustomButton(button: UIImageView(image: Images.newGameButton),
                                                      tapped: UIImageView(image: Images.newGameButtonTap))
    private let continueButton: UIButton = CustomButton(button: UIImageView(image: Images.continueButton),
                                                       tapped: UIImageView(image: Images.continueButtonTap))
    private let learningButton: UIButton = CustomButton(button: UIImageView(image: Images.learningButton),
                                                       tapped: UIImageView(image: Images.learningButtonTap))
    private let chooseCrownsButton: UIButton = CustomButton(button: UIImageView(image: Images.chooseCrownsButton),
                                                           tapped: UIImageView(image: Images.chooseCrownsButtonTap))
    private let chooseSudokuButton: UIButton = CustomButton(button: UIImageView(image: Images.chooseSudokuButton),
                                                           tapped: UIImageView(image: Images.chooseSudokuButtonTap))
    private let chooseQueensButton: UIButton = CustomButton(button: UIImageView(image: Images.chooseQueensButton),
                                                           tapped: UIImageView(image: Images.chooseQueensButtonTap))
    private let homeLogoPicture = UIImageView(image: Images.homeLogoPicture)
    private let homeLogoText = CustomText(text: Text.homeLogo, fontSize: Constraints.homeLogoSize, textColor: Colors.white)
    private let homeCalendar = UIImageView(image: Images.homeCalendar)
    private let chooseGameText = CustomText(text: Text.chooseGame, fontSize: Constraints.selectorTextSize, textColor: Colors.white)
    private let chooseLearningText = CustomText(text: Text.chooseLearning, fontSize: Constraints.selectorTextSize, textColor: Colors.white)
    var presenter: HomePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        configureUI()
    }
    
    private func configureUI() {
        configureBackground()
        configureCalendar()
        configureButtons()
        configureOverlay()
        configureGameSelector()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        view.addSubview(homeLogoPicture)
        view.addSubview(homeLogoText)
        
        NSLayoutConstraint.activate([
            homeLogoPicture.pinCenterX(to: view),
            homeLogoPicture.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.homeLogoPictureTop),
            homeLogoText.pinCenterX(to: view),
            homeLogoText.pinTop(to: homeLogoPicture.bottomAnchor, Constraints.homeLogoTextTop)
        ])
    }
    
    private func configureCalendar() {
        view.addSubview(homeCalendar)
        
        NSLayoutConstraint.activate([
            homeCalendar.pinCenterX(to: view),
            homeCalendar.pinTop(to: homeLogoText.bottomAnchor, Constraints.homeCalendarTop)
        ])
    }
    
    private func configureButtons() {
        newGameButton.tag = Numbers.newGameButtonTag
        learningButton.tag = Numbers.learningButtonTag
        
        view.addSubview(newGameButton)
        view.addSubview(continueButton)
        view.addSubview(learningButton)
        
        NSLayoutConstraint.activate([
            newGameButton.pinCenterX(to: view),
            continueButton.pinCenterX(to: view),
            learningButton.pinCenterX(to: view),
            
            newGameButton.pinTop(to: homeCalendar.bottomAnchor, Constraints.newGameButtonTop),
            continueButton.pinTop(to: newGameButton.bottomAnchor, Constraints.continueButtonTop),
            learningButton.pinTop(to: continueButton.bottomAnchor, Constraints.learningButtonTop)
        ])
        
        newGameButton.addTarget(self, action: #selector(showGameSelector(_:)), for: .touchUpInside)
        learningButton.addTarget(self, action: #selector(showGameSelector(_:)), for: .touchUpInside)
    }
    
    private func configureOverlay() {
        overlayView.frame = view.bounds
        overlayView.backgroundColor = Colors.darkGray
        overlayView.alpha = Numbers.overlayUnvisible
        overlayView.isUserInteractionEnabled = true
        view.addSubview(overlayView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideGameSelector))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    private func configureGameSelector() {
        gameSelectorView.backgroundColor = Colors.darkGray
        gameSelectorView.layer.cornerRadius = Constraints.gameSelectorRadius
        gameSelectorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gameSelectorView.clipsToBounds = false
        gameSelectorView.layer.shadowColor = UIColor.black.cgColor
        gameSelectorView.layer.shadowOffset = CGSize(width: Constraints.gameSelectorShadowWidth,
                                                     height: -Constraints.gameSelectorShadowHeight)
        gameSelectorView.layer.shadowRadius = Constraints.gameSelectorShadowRadius
        gameSelectorView.layer.shadowOpacity = Numbers.gameSelectorShadowUnvisible
        
        view.addSubview(gameSelectorView)
        gameSelectorView.addSubview(chooseGameText)
        gameSelectorView.addSubview(chooseLearningText)
        chooseGameText.isHidden = true
        chooseLearningText.isHidden = true
                
        NSLayoutConstraint.activate([
            gameSelectorView.pinLeft(to: view.leadingAnchor),
            gameSelectorView.pinRight(to: view.trailingAnchor),
            gameSelectorView.setHeight(Constraints.gameSelectorHeight),
            gameSelectorView.pinBottom(to: view.bottomAnchor, -Constraints.gameSelectorHeight),
            chooseGameText.pinCenterX(to: gameSelectorView),
            chooseGameText.pinTop(to: gameSelectorView.topAnchor, Constraints.chooseTextTop),
            chooseLearningText.pinCenterX(to: gameSelectorView),
            chooseLearningText.pinTop(to: gameSelectorView.topAnchor, Constraints.chooseTextTop)
        ])
        
        configureGameSelectorButtons()
    }
    
    private func configureGameSelectorButtons() {
        gameSelectorView.addSubview(chooseCrownsButton)
        gameSelectorView.addSubview(chooseSudokuButton)
        gameSelectorView.addSubview(chooseQueensButton)
        
        NSLayoutConstraint.activate([
            chooseCrownsButton.pinCenterX(to: gameSelectorView),
            chooseSudokuButton.pinCenterX(to: gameSelectorView),
            chooseQueensButton.pinCenterX(to: gameSelectorView),
            
            chooseCrownsButton.pinTop(to: gameSelectorView.topAnchor, Constraints.chooseCrownsButtonTop),
            chooseSudokuButton.pinTop(to: chooseCrownsButton.bottomAnchor, Constraints.chooseSudokuButtonTop),
            chooseQueensButton.pinTop(to: chooseSudokuButton.bottomAnchor, Constraints.chooseQueensButtonTop)
        ])
    }
    
    @objc private func showGameSelector(_ sender: UIButton) {
        UIView.animate(withDuration: Numbers.gameSelectorAnimationDuration) {
            self.overlayView.alpha = Numbers.overlayVisible
            self.gameSelectorView.transform = CGAffineTransform(translationX: 0, y: -Constraints.gameSelectorHeight)
            self.gameSelectorView.layer.shadowOpacity = Numbers.gameSelectorShadowVisible
            if sender.tag == Numbers.newGameButtonTag {
                self.chooseGameText.isHidden = false
                self.chooseCrownsButton.addTarget(self, action: #selector(self.playCrowns), for: .touchUpInside)
                self.chooseSudokuButton.addTarget(self, action: #selector(self.playSudoku), for: .touchUpInside)
                self.chooseQueensButton.addTarget(self, action: #selector(self.playQueens), for: .touchUpInside)
            } else {
                self.chooseLearningText.isHidden = false
                self.chooseCrownsButton.addTarget(self, action: #selector(self.learnCrowns), for: .touchUpInside)
                self.chooseSudokuButton.addTarget(self, action: #selector(self.learnSudoku), for: .touchUpInside)
                self.chooseQueensButton.addTarget(self, action: #selector(self.learnQueens), for: .touchUpInside)
            }
        }
    }
    
    @objc private func hideGameSelector() {
        UIView.animate(withDuration: Numbers.gameSelectorAnimationDuration, animations: {
            self.overlayView.alpha = Numbers.overlayUnvisible
            self.gameSelectorView.transform = .identity
            self.gameSelectorView.layer.shadowOpacity = Numbers.gameSelectorShadowUnvisible
            self.chooseGameText.isHidden = true
            self.chooseLearningText.isHidden = true
            self.chooseCrownsButton.removeTarget(nil, action: nil, for: .allEvents)
            self.chooseSudokuButton.removeTarget(nil, action: nil, for: .allEvents)
            self.chooseQueensButton.removeTarget(nil, action: nil, for: .allEvents)
        })
    }
    
    @objc private func playCrowns() {
        presenter?.processPlayButton(for: Numbers.crownsTag)
    }
    
    @objc private func playSudoku() {
        presenter?.processPlayButton(for: Numbers.sudokuTag)
    }
    
    @objc private func playQueens() {
        presenter?.processPlayButton(for: Numbers.queensTag)
    }
    
    @objc private func learnCrowns() {
        presenter?.processLearningButton(for: Numbers.crownsTag)
    }
    
    @objc private func learnSudoku() {
        presenter?.processLearningButton(for: Numbers.sudokuTag)
    }
    
    @objc private func learnQueens() {
        presenter?.processLearningButton(for: Numbers.queensTag)
    }
}
