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
    
    lazy var barButtonItem = UIBarButtonItem()
    var choosenButton: Int = 0
    
    init(interactor: SudokuSettingsBusinessLogic) {
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
        
        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gameLogoTop)
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
        
        for ((button, image), tag) in zip(zip([levelEasyButton, levelMediumButton, levelHardButton, levelRandomButton],
                                              [Images.levelEasyButton, Images.levelMediumButton, Images.levelHardButton, Images.levelRandomButton]),
                                          [Numbers.levelEasyTag, Numbers.levelMediumTag, Numbers.levelHardTag, Numbers.levelRandomTag]) {
            button.setImage(image, for: .normal)
            button.tag = tag
            buttonStack.addArrangedSubview(button)
            button.pinCenterX(to: buttonStack)
        }
        
        view.addSubview(buttonStack)
        
        levelEasyButton.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
        levelMediumButton.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
        levelHardButton.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
        levelRandomButton.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
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
        interactor.startButtonTapped(SudokuSettingsModel.RouteBack.Request())
    }
    
    @objc private func levelButtonTapped(_ sender: UIButton) {
        let tappedImages = [Images.levelEasyButtonTap, Images.levelMediumButtonTap, Images.levelHardButtonTap, Images.levelRandomButtonTap]
        let images = [Images.levelEasyButton, Images.levelMediumButton, Images.levelHardButton, Images.levelRandomButton]
        let buttons = [levelEasyButton, levelMediumButton, levelHardButton, levelRandomButton]
        buttons[choosenButton].setImage(images[choosenButton], for: .normal)
        buttons[sender.tag].setImage(tappedImages[sender.tag], for: .normal)
        choosenButton = sender.tag
    }
    
    @objc private func changedTimerSwitch() {
        if timerSwitch.isOn {
            timerPicker.isHidden = false
        } else {
            timerPicker.isHidden = true
        }
    }
    
}
