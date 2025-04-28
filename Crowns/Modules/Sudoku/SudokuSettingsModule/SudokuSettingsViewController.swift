//
//  SudokuSettingsViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//
import UIKit

final class SudokuSettingsViewController: UIViewController{
    
    private let interactor: SudokuSettingsBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: UIImage.backButton),
                                                    tapped: UIImageView(image: UIImage.backButtonTap))
    private let startPlayButton: UIButton = CustomButton(button: UIImageView(image: UIImage.startPlayButton))
    private let startPlayCat: UIImageView = UIImageView(image: UIImage.startPlayCat)
    private let easyButton: UIButton = UIButton()
    private let mediumButton: UIButton = UIButton()
    private let hardButton: UIButton = UIButton()
    private let randomButton: UIButton = UIButton()
    private let timerSwitch: UISwitch = UISwitch()
    private let timerLabel: UILabel = CustomText(text: Constants.timerText, fontSize: Constants.settingsTextSize, textColor: Colors.white)
    private let timerPicker: TimePickerTextField = TimePickerTextField()
    private let logo: UILabel = CustomText(text: Constants.logoText, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let chooseDifficulty: UILabel = CustomText(text: Constants.chooseDifficultyText, fontSize: Constants.settingsTextSize, textColor: Colors.white)
    private let timerStack:UIStackView = UIStackView()
    private let buttonStack:UIStackView = UIStackView()
    private var levelButtons: [UIButton] = []
    lazy var barButtonItem = UIBarButtonItem()
    private var choosenButton: Int = Constants.choosenButton
    
    init(interactor: SudokuSettingsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        levelButtons = [easyButton, mediumButton, hardButton, randomButton]
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
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureUI() {
        configureTimer()
        configureBackground()
    }
    
    private func configureTimer() {
        timerStack.addArrangedSubview(timerLabel)
        timerStack.addArrangedSubview(timerSwitch)
        timerStack.axis = .horizontal
        timerStack.spacing = Constants.timerStackSpacing
        timerStack.alignment = .center
        timerSwitch.onTintColor = Colors.yellow
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        timerPicker.isHidden = true
        
        for subview in [logo, chooseDifficulty, startPlayButton, timerStack, timerPicker, startPlayCat] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        chooseDifficulty.pinTop(to: logo.bottomAnchor, Constants.chooseDifficultyTop)
        startPlayButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.startPlayButtonBottom)
        timerPicker.setWidth(Constants.timerPickerWidth)
        startPlayCat.pinBottom(to: startPlayButton.topAnchor, Constants.startPlayCatBottom)
        
        configureButtons()
        
        buttonStack.pinTop(to: chooseDifficulty.bottomAnchor, Constants.buttonsStackTop)
        buttonStack.pinCenterX(to: view)
        timerStack.pinTop(to: buttonStack.bottomAnchor, Constants.timerStackTop)
        timerPicker.pinTop(to: timerStack.bottomAnchor, Constants.timerPickerTop)
        
        startPlayButton.addTarget(self, action: #selector(startPlayButtonTapped), for: .touchUpInside)
        timerSwitch.addTarget(self, action: #selector(changedTimerSwitch), for: .valueChanged)
    }
    
    private func configureButtons() {
        buttonStack.axis = .vertical
        buttonStack.spacing = Constants.buttonsStackSpacing
        buttonStack.alignment = .center
        
        for (button, image) in zip([easyButton, mediumButton, hardButton, randomButton],
                                   [UIImage.levelEasyButtonTap, UIImage.levelMediumButton, UIImage.levelHardButton, UIImage.levelRandomButton]) {
            button.setImage(image, for: .normal)
            buttonStack.addArrangedSubview(button)
            button.pinCenterX(to: buttonStack)
        }
        
        view.addSubview(buttonStack)
        
        easyButton.addTarget(self, action: #selector(easyButtonTapped), for: .touchUpInside)
        mediumButton.addTarget(self, action: #selector(mediumButtonTapped), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(hardButtonTapped), for: .touchUpInside)
        randomButton.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(SudokuSettingsModel.RouteBack.Request())
    }
    
    @objc private func startPlayButtonTapped() {
        if timerSwitch.isOn {
            if let time = timerPicker.text {
                interactor.startButtonTapped(SudokuSettingsModel.RouteSudokuGame.Request(buttonTag: choosenButton, timerLabel: time))
            } else {
                interactor.startButtonTapped(SudokuSettingsModel.RouteSudokuGame.Request(buttonTag: choosenButton, timerLabel: Constants.startTimerLabel))
            }
        } else {
            interactor.startButtonTapped(SudokuSettingsModel.RouteSudokuGame.Request(buttonTag: choosenButton, timerLabel: Constants.startTimerLabel))
        }
    }
    
    @objc private func easyButtonTapped() {
        easyButton.setImage(UIImage.levelEasyButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(Constants.untappedImages[choosenButton], for: .normal)
        choosenButton = Constants.easyTag
    }
    
    @objc private func mediumButtonTapped() {
        mediumButton.setImage(UIImage.levelMediumButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(Constants.untappedImages[choosenButton], for: .normal)
        choosenButton = Constants.mediumTag
    }
    
    @objc private func hardButtonTapped() {
        hardButton.setImage(UIImage.levelHardButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(Constants.untappedImages[choosenButton], for: .normal)
        choosenButton = Constants.hardTag
    }
    
    @objc private func randomButtonTapped() {
        randomButton.setImage(UIImage.levelRandomButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(Constants.untappedImages[choosenButton], for: .normal)
        choosenButton = Constants.randomTag
        
    }
    
    @objc private func changedTimerSwitch() {
        if timerSwitch.isOn {
            timerPicker.isHidden = false
        } else {
            timerPicker.isHidden = true
        }
    }
    
    private enum Constants {
        static let logoText: String = "Sudoku"
        static let timerText: String = "Timer"
        static let chooseDifficultyText: String = "Choose the difficulty level:"
        static let startTimerLabel = "00:00"
        
        static let logoTextSize: CGFloat = 34
        static let settingsTextSize: CGFloat = 24
        static let timerStackSpacing: CGFloat = 20
        static let timerPickerWidth: CGFloat = 90
        static let buttonsStackSpacing: CGFloat = 10
        
        static let chooseDifficultyTop: CGFloat = 25
        static let startPlayButtonBottom: CGFloat = 30
        static let startPlayCatBottom: CGFloat = -25
        static let buttonsStackTop: CGFloat = 30
        static let timerStackTop: CGFloat = 30
        static let timerPickerTop: CGFloat = 30
        
        static let choosenButton = 0
        static let easyTag: Int = 0
        static let mediumTag: Int = 1
        static let hardTag: Int = 2
        static let randomTag: Int = 3
        
        static let untappedImages = [UIImage.levelEasyButton, UIImage.levelMediumButton, UIImage.levelHardButton, UIImage.levelRandomButton]
    }
}
