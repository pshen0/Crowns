//
//  SudokuSettingsViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import UIKit

final class SudokuSettingsViewController: UIViewController{
    
    private let interactor: SudokuSettingsBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    private let startPlayButton: UIButton = CustomButton(button: UIImageView(image: Images.startPlayButton))
    private let startPlayCat: UIImageView = UIImageView(image: Images.startPlayCat)
    private let levelEasyButton: UIButton = UIButton()
    private let levelMediumButton: UIButton = UIButton()
    private let levelHardButton: UIButton = UIButton()
    private let levelRandomButton: UIButton = UIButton()
    private let timerSwitch: UISwitch = UISwitch()
    private let timerLabel: UILabel = CustomText(text: Text.timerLabel, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
    private let timerPicker: TimePickerTextField = TimePickerTextField()
    private let gameLogo: UILabel = CustomText(text: Text.sudokuGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    private let choosingDifficultyText: UILabel = CustomText(text: Text.chooseDifficulty, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
    private let timerStack:UIStackView = UIStackView()
    private let buttonStack:UIStackView = UIStackView()
    private let untappedImages = [Images.levelEasyButton, Images.levelMediumButton, Images.levelHardButton, Images.levelRandomButton]
    private var levelButtons: [UIButton] = []
    lazy var barButtonItem = UIBarButtonItem()
    private var choosenButton: Int = 0
    
    init(interactor: SudokuSettingsBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        levelButtons = [levelEasyButton, levelMediumButton, levelHardButton, levelRandomButton]
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
        configureTimer()
        configureBackground()
        configureButtons()
        configureCrowns()
    }
    
    private func configureTimer() {
        timerStack.addArrangedSubview(timerLabel)
        timerStack.addArrangedSubview(timerSwitch)
        timerStack.axis = .horizontal
        timerStack.spacing = Constraints.timerStackSpacing
        timerStack.alignment = .center
        timerSwitch.onTintColor = Colors.yellow
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        timerPicker.isHidden = true
        
        for subview in [gameLogo, choosingDifficultyText, startPlayButton, timerStack, timerPicker, startPlayCat] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gameSettingsLogoTop)
        choosingDifficultyText.pinTop(to: gameLogo.bottomAnchor, Constraints.choosingDifficultyTextTop)
        startPlayButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constraints.startPlayButtonBottom)
        timerPicker.setWidth(Constraints.timerPickerWidth)
        startPlayCat.pinBottom(to: startPlayButton.topAnchor, Constraints.startPlayCatBottom)
        
        startPlayButton.addTarget(self, action: #selector(startPlayButtonTapped), for: .touchUpInside)
        timerSwitch.addTarget(self, action: #selector(changedTimerSwitch), for: .valueChanged)
    }
    
    private func configureButtons() {
        buttonStack.axis = .vertical
        buttonStack.spacing = Constraints.settingsButtonStackSpacing
        buttonStack.alignment = .center
        
        for (button, image) in zip([levelEasyButton, levelMediumButton, levelHardButton, levelRandomButton],
                                   [Images.levelEasyButtonTap, Images.levelMediumButton, Images.levelHardButton, Images.levelRandomButton]) {
            button.setImage(image, for: .normal)
            buttonStack.addArrangedSubview(button)
            button.pinCenterX(to: buttonStack)
        }
        
        view.addSubview(buttonStack)
        
        levelEasyButton.addTarget(self, action: #selector(easyButtonTapped), for: .touchUpInside)
        levelMediumButton.addTarget(self, action: #selector(mediumButtonTapped), for: .touchUpInside)
        levelHardButton.addTarget(self, action: #selector(hardButtonTapped), for: .touchUpInside)
        levelRandomButton.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
    }
    
    private func configureCrowns() {
        buttonStack.pinTop(to: choosingDifficultyText.bottomAnchor, Constraints.settingsButtonStackTop)
        buttonStack.pinCenterX(to: view)
        timerStack.pinTop(to: buttonStack.bottomAnchor, Constraints.timerStackTop)
        timerPicker.pinTop(to: timerStack.bottomAnchor, Constraints.timerPickerTop)
    }
    
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(SudokuSettingsModel.RouteBack.Request())
    }
    
    @objc private func startPlayButtonTapped() {
        interactor.startButtonTapped(SudokuSettingsModel.RouteSudokuGame.Request(buttonTag: choosenButton))
    }
    
    @objc private func easyButtonTapped() {
        levelEasyButton.setImage(Images.levelEasyButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(untappedImages[choosenButton], for: .normal)
        choosenButton = Numbers.levelEasyTag
    }
    
    @objc private func mediumButtonTapped() {
        levelMediumButton.setImage(Images.levelMediumButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(untappedImages[choosenButton], for: .normal)
        choosenButton = Numbers.levelMediumTag
    }
    
    @objc private func hardButtonTapped() {
        levelHardButton.setImage(Images.levelHardButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(untappedImages[choosenButton], for: .normal)
        choosenButton = Numbers.levelHardTag
    }
    
    @objc private func randomButtonTapped() {
        levelRandomButton.setImage(Images.levelRandomButtonTap, for: .normal)
        levelButtons[choosenButton].setImage(untappedImages[choosenButton], for: .normal)
        choosenButton = Numbers.levelRandomTag
        
    }
    
    @objc private func changedTimerSwitch() {
        if timerSwitch.isOn {
            timerPicker.isHidden = false
        } else {
            timerPicker.isHidden = true
        }
    }
    
}
