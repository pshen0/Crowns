//
//  QueensSettingsViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import UIKit

final class QueensSettingsViewController: UIViewController {
    
    private let interactor: QueensSettingsBusinessLogic
    
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    private let startPlayButton: UIButton = CustomButton(button: UIImageView(image: Images.startPlayButton))
    private let startPlayCat: UIImageView = UIImageView(image: Images.startPlayCat)
    private let numberField: CustomNumberPicker = CustomNumberPicker()
    private let timerSwitch: UISwitch = UISwitch()
    private let timerLabel: UILabel = CustomText(text: Text.timerLabel, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
    private let timerPicker: TimePickerTextField = TimePickerTextField()
    private let gameLogo: UILabel = CustomText(text: Text.queensGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    
    let choosingDifficultyText: UILabel = CustomText(text: Text.chooseFieldsSize, fontSize: Constraints.settingsTextSize, textColor: Colors.white)
    let blocker = UIView()
    lazy var timerStackView:UIStackView = UIStackView()
    lazy var barButtonItem = UIBarButtonItem()
    
    init(interactor: QueensSettingsBusinessLogic) {
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
        configureQueensSettings()
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
        
        for subview in [gameLogo, choosingDifficultyText, startPlayButton, timerStackView, timerPicker, startPlayCat] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }

        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gameLogoTop)
        choosingDifficultyText.pinTop(to: gameLogo.bottomAnchor, Constraints.choosingDifficultyTextTop)
        startPlayButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constraints.startPlayButtonBottom)
        timerPicker.setWidth(Constraints.timerPickerWidth)
        startPlayCat.pinBottom(to: startPlayButton.topAnchor, Constraints.startPlayCatBottom)
        
        startPlayButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        timerSwitch.addTarget(self, action: #selector(changedTimerSwitch), for: .valueChanged)
    }
    
    private func configureQueensSettings () {
        view.addSubview(numberField)
        
        numberField.pinCenterY(to: choosingDifficultyText)
        numberField.setWidth(Constraints.numberFieldWidth)
        numberField.pinLeft(to: choosingDifficultyText.trailingAnchor, Constraints.numberFieldLeft)
        timerStackView.pinTop(to: choosingDifficultyText.bottomAnchor, Constraints.timerStackTop)
        timerPicker.pinTop(to: timerStackView.bottomAnchor, Constraints.timerPickerTop)
    }
    
    @objc
    private func backButtonTapped() {
        interactor.backButtonTapped(QueensSettingsModel.RouteBack.Request())
    }
    
    @objc
    private func startButtonTapped() {
        interactor.startButtonTapped(QueensSettingsModel.RouteBack.Request())
    }
    
    @objc
    private func changedTimerSwitch() {
        if timerSwitch.isOn {
            timerPicker.isHidden = false
        } else {
            timerPicker.isHidden = true
        }
    }
}
