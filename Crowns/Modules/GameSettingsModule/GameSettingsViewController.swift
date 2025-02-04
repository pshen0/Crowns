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
    
    var presenter: GameSettingsPresenterProtocol?
    lazy var game: Int = Numbers.crownsTag
    lazy var gameLogo: UILabel = UILabel()
    lazy var choosingDifficultyText: UILabel = UILabel()
    
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
        fatalError(Text.initError)
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
        configureBackground()
        if self.game == Numbers.queensTag {
            configureQueensSettings()
        } else {
            configureCrownsOrSudokuSettings()
        }
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        
        view.addSubview(gameLogo)
        view.addSubview(choosingDifficultyText)
        view.addSubview(startPlayButton)
        NSLayoutConstraint.activate([
            gameLogo.pinCenterX(to: view),
            gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gameLogoTop),
            choosingDifficultyText.pinCenterX(to: view),
            choosingDifficultyText.pinTop(to: gameLogo.bottomAnchor, Constraints.choosingDifficultyTextTop),
            startPlayButton.pinCenterX(to: view),
            startPlayButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constraints.startPlayButtonBottom),
        ])
        startPlayButton.addTarget(self, action: #selector(startPlayButtonTapped), for: .touchUpInside)
        
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
            levelRandomButton.pinTop(to: levelHardButton.bottomAnchor, Constraints.levelButtonTop)
        ])
        
        
        
        levelEasyButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        levelMediumButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        levelHardButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        levelRandomButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        
    }
    
    private func configureQueensSettings () {
    
    }
    
    
    @objc private func backButtonTapped() {        
        presenter?.processBackButton()
    }
    
    @objc private func startPlayButtonTapped() {
        presenter?.processStartButton(for: game)
    }
    
    @objc private func levelButtonTapped(_ sender: UIButton) {
        if sender.tag == Numbers.levelEasyTag {
            levelEasyButton.setImage(Images.levelEasyButtonTap, for: .normal)
            levelMediumButton.setImage(Images.levelMediumButton, for: .normal)
            levelHardButton.setImage(Images.levelHardButton, for: .normal)
            levelRandomButton.setImage(Images.levelRandomButton, for: .normal)
        } else if sender.tag == Numbers.levelMediumTag {
            levelEasyButton.setImage(Images.levelEasyButton, for: .normal)
            levelMediumButton.setImage(Images.levelMediumButtonTap, for: .normal)
            levelHardButton.setImage(Images.levelHardButton, for: .normal)
            levelRandomButton.setImage(Images.levelRandomButton, for: .normal)
        } else if sender.tag == Numbers.levelHardTag {
            levelEasyButton.setImage(Images.levelEasyButton, for: .normal)
            levelMediumButton.setImage(Images.levelMediumButton, for: .normal)
            levelHardButton.setImage(Images.levelHardButtonTap, for: .normal)
            levelRandomButton.setImage(Images.levelRandomButton, for: .normal)
        } else {
            levelEasyButton.setImage(Images.levelEasyButton, for: .normal)
            levelMediumButton.setImage(Images.levelMediumButton, for: .normal)
            levelHardButton.setImage(Images.levelHardButton, for: .normal)
            levelRandomButton.setImage(Images.levelRandomButtonTap, for: .normal)
        }
    }
}
