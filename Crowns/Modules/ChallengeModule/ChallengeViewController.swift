//
//  ChallengeViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

final class ChallengeViewController: UIViewController {
    
    private let interactor: ChallengeBusinessLogic
    private let challengeLogo = CustomText(text: Text.challengeLogo, fontSize: Constraints.challengeLogoSize, textColor: Colors.white)
    private let lightning1: UIImageView = UIImageView(image: Images.lightning1)
    private let lightning2: UIImageView = UIImageView(image: Images.lightning2)
    private let lightningAnimation1: UIImageView = UIImageView(image: Images.lightning1)
    private let lightningAnimation2: UIImageView = UIImageView(image: Images.lightning2)
    private let challengeCat: BlinkingCatView = BlinkingCatView(images: Images.blinkingCatArray, duration: Numbers.blinkingAnimationDuration, repeatCount: Numbers.blinkingRepeat)
    private let challengeMice: UIImageView = UIImageView(image: Images.challengeMice)
    private let challengeCrownsButton: UIButton = CustomButton(button: UIImageView(image: Images.challengeCrownsButton))
    private let challengeSudokuButton: UIButton = CustomButton(button: UIImageView(image: Images.challengeSudokuButton))
    private let challengeCompletedLevelButton: UIButton = CustomButton(button: UIImageView(image: Images.challengeCompletedLevel))
    private let challengeCalendar = CustomCalendar()
    private let streakText = CustomText(text: Text.streak, fontSize: Constraints.streakTextSize, textColor: Colors.white)

    var timer: Timer?
    
    init(interactor: ChallengeBusinessLogic) {
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func configureUI() {
        configureBackground()
        startTimer()
        catStartsBlinking()
        configureCalendar()
        configureButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        lightning1.alpha = Numbers.lightningBackVisible
        lightning2.alpha = Numbers.lightningBackVisible
        lightningAnimation1.alpha = Numbers.lightningAnimationUnvisible
        lightningAnimation2.alpha = Numbers.lightningAnimationUnvisible
        
        
        for (subview, top) in zip([lightning1, lightning2, lightningAnimation1, lightningAnimation2, challengeLogo, challengeCat, challengeMice],
                                  [Constraints.lightning1Top, Constraints.lightning2Top, Constraints.lightningAnimation1Top,
                                   Constraints.lightningAnimation2Top, Constraints.challengeLogoTextTop, Constraints.challengeCatTop,
                                   Constraints.challengeMiceTop]) {
            view.addSubview(subview)
            subview.pinTop(to: view.safeAreaLayoutGuide.topAnchor, top)
        }
        
        challengeLogo.pinCenterX(to: view)
        lightning1.pinLeft(to: view, Constraints.lightning1Left)
        lightning2.pinRight(to: view, Constraints.lightning2Right)
        lightningAnimation1.pinLeft(to: view, Constraints.lightningAnimation1Left)
        lightningAnimation2.pinRight(to: view, Constraints.lightningAnimation2Right)
        challengeCat.pinLeft(to: view, Constraints.challengeCatLeft)
        challengeMice.pinRight(to: view, Constraints.challengeMiceRight)
    }
    
    private func configureCalendar() {
        view.addSubview(challengeCalendar)
        view.addSubview(streakText)
        
        challengeCalendar.setWidth(Constraints.challengeCalendarWidth)
        challengeCalendar.setHeight(Constraints.challengeCalendarHeight)
        challengeCalendar.pinCenterX(to: view)
        challengeCalendar.pinTop(to: challengeCat.bottomAnchor, Constraints.challengeCalendarTop)
        streakText.pinBottom(to: challengeCalendar.topAnchor, 10)
        streakText.pinRight(to: challengeCalendar.trailingAnchor, 10)
        
    }
    
    private func configureButtons() {
        view.addSubview(challengeCrownsButton)
        view.addSubview(challengeSudokuButton)
        
        challengeCrownsButton.pinCenterX(to: view)
        challengeCrownsButton.pinTop(to: challengeCalendar.bottomAnchor, Constraints.challengeCrownsButtonTop)
        challengeSudokuButton.pinCenterX(to: view)
        challengeSudokuButton.pinTop(to: challengeCrownsButton.bottomAnchor, Constraints.challengeSudokuButtonTop)
        
        challengeCrownsButton.addTarget(self, action: #selector(crownsButtonTapped), for: .touchUpInside)
        challengeSudokuButton.addTarget(self, action: #selector(sudokuButtonTapped), for: .touchUpInside)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Numbers.lightningAnimationDuration, target: self, selector: #selector(animateLightnings), userInfo: nil, repeats: true)
    }
    
    
    @objc func animateLightnings() {
        UIView.animate(withDuration: Numbers.lightningAppearanceDuration) {
            self.lightningAnimation1.alpha = Numbers.lightningAnimationVisible
        }
        UIView.animate(withDuration: Numbers.lightningAppearanceDuration) {
            self.lightningAnimation1.alpha = Numbers.lightningAnimationUnvisible
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Numbers.lightningAnimationDuration / 2) {
            UIView.animate(withDuration: Numbers.lightningAppearanceDuration) {
                self.lightningAnimation2.alpha = Numbers.lightningAnimationVisible
            }
            UIView.animate(withDuration: Numbers.lightningAppearanceDuration) {
                self.lightningAnimation2.alpha = Numbers.lightningAnimationUnvisible
            }
        }
    }
    
    private func catStartsBlinking() {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 2...4), repeats: true) { _ in
            self.challengeCat.startBlinking()
        }
    }
    
    @objc
    private func crownsButtonTapped() {
        interactor.crownsButtonTapped(ChallengeModel.RouteCrownsGame.Request())
    }
    
    @objc
    private func sudokuButtonTapped() {
        interactor.sudokuButtonTapped(ChallengeModel.RouteSudokuGame.Request())
    }
}
