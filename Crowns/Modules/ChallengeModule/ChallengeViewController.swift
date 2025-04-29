//
//  ChallengeViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

// MARK: - ChallengeViewController class
final class ChallengeViewController: UIViewController {
    
    // MARK: - Properties
    private let interactor: ChallengeBusinessLogic
    private let logo = CustomText(text: Constants.logoText, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let lightning1: UIImageView = UIImageView(image: UIImage.lightning1)
    private let lightning2: UIImageView = UIImageView(image: UIImage.lightning2)
    private let clouds: UIImageView = UIImageView(image: UIImage.clouds)
    private let lightningAnimation1: UIImageView = UIImageView(image: UIImage.lightning1)
    private let lightningAnimation2: UIImageView = UIImageView(image: UIImage.lightning2)
    private let cat: BlinkingCatView = BlinkingCatView(images: Constants.blinkingCatArray, duration: Constants.blinkingAnimationDuration, repeatCount: Constants.blinkingRepeat)
    private let mice: UIImageView = UIImageView(image: UIImage.challengeMice)
    private let crownsButton: UIButton = CustomButton(button: UIImageView(image: UIImage.challengeCrownsButton))
    private let sudokuButton: UIButton = CustomButton(button: UIImageView(image: UIImage.challengeSudokuButton))
    private let calendar = CustomCalendar()
    private var streakText = CustomText(text: Constants.streakText, fontSize: Constants.streakTextSize, textColor: Colors.white)
    
    private var thunderTimer: Timer?
    private var catTimer: Timer?
    
    // MARK: - Lifecycle
    init(interactor: ChallengeBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        stopAnimateChallengesScreen()
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
        startAnimateChallengesScreen()
        calendar.updateMarkedDates()
        interactor.updateButtons(ChallengeModel.ResetChallenges.Request())
        interactor.setupDailyResetObserver(ChallengeModel.ResetChallenges.Request())
        interactor.getStreak(ChallengeModel.GetStreak.Request())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimateChallengesScreen()
    }
    
    // MARK: - Funcs
    func updateScreen(_ viewModel: ChallengeModel.ResetChallenges.ViewModel) {
        crownsButton.isEnabled = viewModel.crownsAccessibility
        sudokuButton.isEnabled = viewModel.sudokusAccessibility

        crownsButton.alpha = viewModel.crownsAccessibility ? Constants.buttonVisabilityMax : Constants.buttonVisabilityMin
        sudokuButton.alpha = viewModel.sudokusAccessibility ? Constants.buttonVisabilityMax : Constants.buttonVisabilityMin
        
        calendar.today = Date()
        calendar.reloadData()
        
        interactor.getStreak(ChallengeModel.GetStreak.Request())
    }
    
    func changeStreakLabel(_ viewModel: ChallengeModel.GetStreak.ViewModel) {
        streakText.text = viewModel.streakLabel
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        configureBackground()
        configureCalendar()
        configureButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        lightningAnimation1.alpha = Constants.lightningUnvisible
        lightningAnimation2.alpha = Constants.lightningUnvisible
        
        
        for (subview, top) in zip([clouds, lightningAnimation1, lightningAnimation2, logo, cat, mice],
                                  [Constants.cloudsTop, Constants.lightningAnimation1Top,
                                   Constants.lightningAnimation2Top, Constants.logoTextTop, Constants.catTop,
                                   Constants.miceTop]) {
            view.addSubview(subview)
            subview.pinTop(to: view.safeAreaLayoutGuide.topAnchor, top)
        }
        
        logo.pinCenterX(to: view)
        lightningAnimation1.pinLeft(to: view, Constants.lightningAnimation1Left)
        lightningAnimation2.pinRight(to: view, Constants.lightningAnimation2Right)
        cat.pinLeft(to: view, Constants.catLeft)
        mice.pinRight(to: view, Constants.miceRight)
        clouds.pinCenterX(to: view)
    }
    
    private func configureCalendar() {
        view.addSubview(calendar)
        view.addSubview(streakText)
        
        calendar.setWidth(Constants.calendarWidth)
        calendar.setHeight(Constants.calendarHeight)
        calendar.pinCenterX(to: view)
        calendar.pinTop(to: cat.bottomAnchor, Constants.calendarTop)
        streakText.pinBottom(to: calendar.topAnchor, Constants.streakTextBottom)
        streakText.pinRight(to: calendar.trailingAnchor, Constants.streakTextRight)
        
    }
    
    private func configureButtons() {
        view.addSubview(crownsButton)
        view.addSubview(sudokuButton)
        
        crownsButton.pinCenterX(to: view)
        crownsButton.pinTop(to: calendar.bottomAnchor, Constants.crownsButtonTop)
        sudokuButton.pinCenterX(to: view)
        sudokuButton.pinTop(to: crownsButton.bottomAnchor, Constants.sudokuButtonTop)
        
        crownsButton.addTarget(self, action: #selector(crownsButtonTapped), for: .touchUpInside)
        sudokuButton.addTarget(self, action: #selector(sudokuButtonTapped), for: .touchUpInside)
    }
    
    private func startAnimateChallengesScreen() {
        self.cat.startBlinking()
        thunderTimer = Timer.scheduledTimer(timeInterval: Constants.lightningAnimationDuration, target: self, selector: #selector(animateLightnings), userInfo: nil, repeats: true)
        catTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: Constants.animationDurMin...Constants.animationDurMax), repeats: true) { _ in
            self.cat.startBlinking()
        }
    }
    
    private func stopAnimateChallengesScreen() {
        cat.stopBlinking()
        catTimer?.invalidate()
        thunderTimer?.invalidate()
        thunderTimer = nil
        catTimer = nil
    }
    
    // MARK: - Actions
    @objc func animateLightnings() {
        UIView.animate(withDuration: Constants.lightningAppearanceDuration) {
            self.lightningAnimation1.alpha = Constants.lightningAnimationVisible
        }
        UIView.animate(withDuration: Constants.lightningAppearanceDuration) {
            self.lightningAnimation1.alpha = Constants.lightningUnvisible
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.lightningAnimationDuration / 2) {
            UIView.animate(withDuration: Constants.lightningAppearanceDuration) {
                self.lightningAnimation2.alpha = Constants.lightningAnimationVisible
            }
            UIView.animate(withDuration: Constants.lightningAppearanceDuration) {
                self.lightningAnimation2.alpha = Constants.lightningUnvisible
            }
        }
    }
    
    @objc private func crownsButtonTapped() {
        interactor.crownsButtonTapped(ChallengeModel.RouteCrownsGame.Request())
    }
    
    @objc private func sudokuButtonTapped() {
        interactor.sudokuButtonTapped(ChallengeModel.RouteSudokuGame.Request())
    }
    
    // MARK: - Constants
    private enum Constants {
        static let logoText: String = "The daily challenge\nCAT AND MOUSE"
        static let streakText: String = "Current streak: 0"
        
        static let logoTextSize: CGFloat = 35
        static let streakTextSize: CGFloat = 17
        static let calendarWidth: CGFloat = 350
        static let calendarHeight: CGFloat = 200
        
        static let cloudsTop: CGFloat = -140
        static let lightningAnimation1Top: CGFloat = -110
        static let lightningAnimation1Left: CGFloat = 210
        static let lightningAnimation2Top: CGFloat = -120
        static let lightningAnimation2Right: CGFloat = 210
        static let logoTextTop: CGFloat = 45
        static let catTop: CGFloat = 150
        static let catLeft: CGFloat = 10
        static let miceTop: CGFloat = 180
        static let miceRight: CGFloat = 20
        static let calendarTop: CGFloat = 55
        static let crownsButtonTop: CGFloat = 25
        static let sudokuButtonTop: CGFloat = 8
        static let streakTextBottom: CGFloat = 10
        static let streakTextRight: CGFloat = 10
        
        
        static let animationDurMin: Double = 3.0
        static let animationDurMax: Double = 5.0
        static let buttonVisabilityMin = 0.5
        static let buttonVisabilityMax = 1.0
        static let blinkingAnimationDuration: Double = 0.6
        static let blinkingRepeat: Int = 1
        static let lightningUnvisible: Double = 0
        static let lightningAnimationVisible: Double = 1
        static let lightningAnimationDuration: Double = 6.0
        static let lightningAppearanceDuration: Double = 0.5
        
        static let blinkingCatArray = [UIImage.challengeBlinkingCat1, UIImage.challengeBlinkingCat2, UIImage.challengeBlinkingCat3, UIImage.challengeBlinkingCat4,
                                        UIImage.challengeBlinkingCat5, UIImage.challengeBlinkingCat6, UIImage.challengeBlinkingCat7]
    }
}
