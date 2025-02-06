//
//  GameSettingsViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 02.02.2025.
//

import UIKit

protocol GameSettingsViewProtocol: AnyObject {
    
}

final class GameSettingsViewController: UIViewController, GameSettingsViewProtocol{
    
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    private let startPlayButton: UIButton = CustomButton(button: UIImageView(image: Images.startPlayButton),
                                                         tapped: UIImageView(image: Images.startPlayButtonTap))
    private let levelEasyButton: UIButton = UIButton()
    private let levelMediumButton: UIButton = UIButton()
    private let levelHardButton: UIButton = UIButton()
    private let levelRandomButton: UIButton = UIButton()
    private let numberField: CustomNumberPicker = CustomNumberPicker()
    private let timerSwitch: UISwitch = UISwitch()
    private let timerLabel: UILabel = CustomText(text: Text.timerLabel, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
    private let timerPicker: TimePickerTextField = TimePickerTextField()
    
    var presenter: GameSettingsPresenterProtocol?
    lazy var game: Int = Numbers.crownsTag
    lazy var gameLogo: UILabel = UILabel()
    lazy var choosingDifficultyText: UILabel = UILabel()
    lazy var timerStackView:UIStackView = UIStackView()
    lazy var barButtonItem = UIBarButtonItem()
    
    init(for game: Int) {
        super.init(nibName: nil, bundle: nil)
        self.game = game
        if game == Numbers.crownsTag {
            gameLogo = CustomText(text: Text.crownsGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
            choosingDifficultyText = CustomText(text: Text.chooseDifficulty, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
        } else if game == Numbers.sudokuTag {
            gameLogo = CustomText(text: Text.sudokuGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
            choosingDifficultyText = CustomText(text: Text.chooseDifficulty, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
        } else {
            gameLogo = CustomText(text: Text.queensGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
            choosingDifficultyText = CustomText(text: Text.chooseFieldsSize, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
        }
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
        if self.game == Numbers.queensTag {
            configureQueensSettings()
        } else {
            configureCrownsOrSudokuSettings()
        }
    }
    
    private func configureTimer() {
        timerStackView = UIStackView(arrangedSubviews: [timerLabel, timerSwitch])
        timerStackView.axis = .horizontal
        timerStackView.spacing = Constraints.timerStackSpacing
        timerStackView.alignment = .center
        timerSwitch.onTintColor = Colors.yellow
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        timerPicker.isHidden = true
        
        view.addSubview(gameLogo)
        view.addSubview(choosingDifficultyText)
        view.addSubview(startPlayButton)
        view.addSubview(timerStackView)
        view.addSubview(timerPicker)
        
        NSLayoutConstraint.activate([
            gameLogo.pinCenterX(to: view),
            gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gameLogoTop),
            choosingDifficultyText.pinCenterX(to: view),
            choosingDifficultyText.pinTop(to: gameLogo.bottomAnchor, Constraints.choosingDifficultyTextTop),
            startPlayButton.pinCenterX(to: view),
            startPlayButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constraints.startPlayButtonBottom),
            timerStackView.pinCenterX(to: view),
            timerPicker.pinCenterX(to: view),
            timerPicker.setWidth(Constraints.timerPickerWidth)
        ])
        startPlayButton.addTarget(self, action: #selector(startPlayButtonTapped), for: .touchUpInside)
        timerSwitch.addTarget(self, action: #selector(changedTimerSwitch), for: .valueChanged)
    }
    
    private func configureCrownsOrSudokuSettings () {
        levelEasyButton.setImage(Images.levelEasyButton, for: .normal)
        levelMediumButton.setImage(Images.levelMediumButton, for: .normal)
        levelHardButton.setImage(Images.levelHardButton, for: .normal)
        levelRandomButton.setImage(Images.levelRandomButton, for: .normal)
        levelEasyButton.tag = Numbers.levelEasyTag
        levelMediumButton.tag = Numbers.levelMediumTag
        levelHardButton.tag = Numbers.levelHardTag
        levelRandomButton.tag = Numbers.levelRandomTag
        
        view.addSubview(levelEasyButton)
        view.addSubview(levelMediumButton)
        view.addSubview(levelHardButton)
        view.addSubview(levelRandomButton)
        
        NSLayoutConstraint.activate([
            levelEasyButton.pinCenterX(to: view),
            levelMediumButton.pinCenterX(to: view),
            levelHardButton.pinCenterX(to: view),
            levelRandomButton.pinCenterX(to: view),
            levelEasyButton.pinTop(to: choosingDifficultyText.bottomAnchor, Constraints.levelEasyButtonTop),
            levelMediumButton.pinTop(to: levelEasyButton.bottomAnchor, Constraints.levelButtonTop),
            levelHardButton.pinTop(to: levelMediumButton.bottomAnchor, Constraints.levelButtonTop),
            levelRandomButton.pinTop(to: levelHardButton.bottomAnchor, Constraints.levelButtonTop),
            timerStackView.pinTop(to: levelRandomButton.bottomAnchor, Constraints.timerStackTop),
            timerPicker.pinTop(to: timerStackView.bottomAnchor, Constraints.timerPickerTop)
        ])
        
        levelEasyButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        levelMediumButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        levelHardButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        levelRandomButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        
    }
    
    private func configureQueensSettings () {
        view.addSubview(numberField)
        
        NSLayoutConstraint.activate([
            numberField.pinCenterY(to: choosingDifficultyText),
            numberField.setWidth(Constraints.numberFieldWidth),
            numberField.pinLeft(to: choosingDifficultyText.trailingAnchor, Constraints.numberFieldLeft),
            timerStackView.pinTop(to: choosingDifficultyText.bottomAnchor, Constraints.timerStackTop),
            timerPicker.pinTop(to: timerStackView.bottomAnchor, Constraints.timerPickerTop)
        ])
    }
    
    
    @objc private func backButtonTapped() {
        presenter?.processBackButton()
    }
    
    @objc private func startPlayButtonTapped() {
        presenter?.processStartButton(for: game)
    }
    
    @objc private func levelButtonTapped(_ sender: UIButton) {
        levelEasyButton.setImage(Images.levelEasyButton, for: .normal)
        levelMediumButton.setImage(Images.levelMediumButton, for: .normal)
        levelHardButton.setImage(Images.levelHardButton, for: .normal)
        levelRandomButton.setImage(Images.levelRandomButton, for: .normal)
        if sender.tag == Numbers.levelEasyTag {
            levelEasyButton.setImage(Images.levelEasyButtonTap, for: .normal)
        } else if sender.tag == Numbers.levelMediumTag {
            levelMediumButton.setImage(Images.levelMediumButtonTap, for: .normal)
        } else if sender.tag == Numbers.levelHardTag {
            levelHardButton.setImage(Images.levelHardButtonTap, for: .normal)
        } else {
            levelRandomButton.setImage(Images.levelRandomButtonTap, for: .normal)
        }
    }
    
    @objc private func changedTimerSwitch() {
        if timerSwitch.isOn {
            timerPicker.isHidden = false
        } else {
            timerPicker.isHidden = true
        }
    }
    
}
