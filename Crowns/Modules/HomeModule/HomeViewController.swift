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
    private let homeLogo = UIImageView(image: Images.homeLogo)
    private let homeCalendar = UIImageView(image: Images.homeCalendar)
    private let chooseGameText = UIImageView(image: Images.chooseGameText)
    private let chooseLearningText = UIImageView(image: Images.chooseLearningText)
    
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
        view.addSubview(homeLogo)
        
        NSLayoutConstraint.activate([
            homeLogo.pinCenterX(to: view),
            homeLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Numbers.logoTop)
        ])
    }
    
    private func configureCalendar() {
        view.addSubview(homeCalendar)
        
        NSLayoutConstraint.activate([
            homeCalendar.pinCenterX(to: view),
            homeCalendar.pinTop(to: homeLogo.bottomAnchor, Numbers.homeCalendarTop)
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
            
            newGameButton.pinTop(to: homeCalendar.bottomAnchor, Numbers.newGameButtonTop),
            continueButton.pinTop(to: newGameButton.bottomAnchor, Numbers.continueButtonTop),
            learningButton.pinTop(to: continueButton.bottomAnchor, Numbers.learningButtonTop)
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
        gameSelectorView.layer.cornerRadius = Numbers.gameSelectorRadius
        gameSelectorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gameSelectorView.clipsToBounds = false
        gameSelectorView.layer.shadowColor = UIColor.black.cgColor
        gameSelectorView.layer.shadowOffset = CGSize(width: Numbers.gameSelectorShadowWidth,
                                                     height: -Numbers.gameSelectorShadowHeight)
        gameSelectorView.layer.shadowRadius = Numbers.gameSelectorShadowRadius
        gameSelectorView.layer.shadowOpacity = Numbers.gameSelectorShadowUnvisible
        
        view.addSubview(gameSelectorView)
        gameSelectorView.addSubview(chooseGameText)
        gameSelectorView.addSubview(chooseLearningText)
        chooseGameText.isHidden = true
        chooseLearningText.isHidden = true
                
        NSLayoutConstraint.activate([
            gameSelectorView.pinLeft(to: view.leadingAnchor),
            gameSelectorView.pinRight(to: view.trailingAnchor),
            gameSelectorView.setHeight(Numbers.gameSelectorHeight),
            gameSelectorView.pinBottom(to: view.bottomAnchor, -Numbers.gameSelectorHeight),
            chooseGameText.pinCenterX(to: gameSelectorView),
            chooseGameText.pinTop(to: gameSelectorView.topAnchor, Numbers.chooseTextTop),
            chooseLearningText.pinCenterX(to: gameSelectorView),
            chooseLearningText.pinTop(to: gameSelectorView.topAnchor, Numbers.chooseTextTop)
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
            
            chooseCrownsButton.pinTop(to: gameSelectorView.topAnchor, Numbers.chooseCrownsButtonTop),
            chooseSudokuButton.pinTop(to: chooseCrownsButton.bottomAnchor, Numbers.chooseSudokuButtonTop),
            chooseQueensButton.pinTop(to: chooseSudokuButton.bottomAnchor, Numbers.chooseQueensButtonTop)
        ])
    }
    
    @objc private func showGameSelector(_ sender: UIButton) {
        UIView.animate(withDuration: Numbers.gameSelectorAnimationDuration) {
            self.overlayView.alpha = Numbers.overlayVisible
            self.gameSelectorView.transform = CGAffineTransform(translationX: 0, y: -Numbers.gameSelectorHeight)
            self.gameSelectorView.layer.shadowOpacity = Numbers.gameSelectorShadowVisible
            if sender.tag == 0 {
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
        presenter?.playButtonTapped(for: Numbers.crownsTag)
    }
    
    @objc private func playSudoku() {
        presenter?.playButtonTapped(for: Numbers.sudokuTag)
    }
    
    @objc private func playQueens() {
        presenter?.playButtonTapped(for: Numbers.queensTag)
    }
    
    @objc private func learnCrowns() {
        presenter?.learningButtonTapped(for: Numbers.crownsTag)
    }
    
    @objc private func learnSudoku() {
        presenter?.learningButtonTapped(for: Numbers.sudokuTag)
    }
    
    @objc private func learnQueens() {
        presenter?.learningButtonTapped(for: Numbers.queensTag)
    }
}
