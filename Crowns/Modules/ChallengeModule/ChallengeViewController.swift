//
//  ChallengeViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

protocol ChallengeViewProtocol: AnyObject {
    
}

final class ChallengeViewController: UIViewController, ChallengeViewProtocol{
    
    private let challengeLogo: UIImageView = UIImageView(image: Images.challengeLogo)
    private let lightning1: UIImageView = UIImageView(image: Images.lightning1)
    private let lightning2: UIImageView = UIImageView(image: Images.lightning2)
    private let lightningAnimation1: UIImageView = UIImageView(image: Images.lightning1)
    private let lightningAnimation2: UIImageView = UIImageView(image: Images.lightning2)
    private let challengeCat: BlinkingCatView = BlinkingCatView()
    private let challengeMice: UIImageView = UIImageView(image: Images.challengeMice)
    private let challengeCrownsButton: UIButton = CustomButton(button: UIImageView(image: Images.challengeCrownsButton),
                                                      tapped: UIImageView(image: Images.challengeCrownsButtonTap))
    private let challengeSudokuButton: UIButton = CustomButton(button: UIImageView(image: Images.challengeSudokuButton),
                                                       tapped: UIImageView(image: Images.challengeSudokuButtonTap))
    private let challengeCompletedLevelButton: UIButton = CustomButton(button: UIImageView(image: Images.challengeCompletedLevel),
                                                       tapped: UIImageView(image: Images.challengeCompletedLevelTap))
    private let challengeCalendar: UIImageView = UIImageView(image: Images.challengeCalendar)
    
    var presenter: ChallengePresenterProtocol?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        configureUI()
    }
    
    private func configureUI() {
        configureBackground()
        startTimer()
        catStartsBlinking()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        lightning1.alpha = Numbers.lightningBackVisible
        lightning2.alpha = Numbers.lightningBackVisible
        lightningAnimation1.alpha = Numbers.lightningAnimationUnvisible
        lightningAnimation2.alpha = Numbers.lightningAnimationUnvisible
        
        view.addSubview(lightning1)
        view.addSubview(lightning2)
        view.addSubview(lightningAnimation1)
        view.addSubview(lightningAnimation2)
        view.addSubview(challengeLogo)
        view.addSubview(challengeCat)
        view.addSubview(challengeMice)
        view.addSubview(challengeCalendar)
        view.addSubview(challengeCrownsButton)
        view.addSubview(challengeSudokuButton)
        
        NSLayoutConstraint.activate([
            challengeLogo.pinCenterX(to: view),
            challengeLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Numbers.logoTop),
            lightning1.pinTop(to: view.topAnchor, Numbers.lightning1Top),
            lightning1.pinLeft(to: view, Numbers.lightning1Left),
            lightning2.pinTop(to: view.topAnchor, Numbers.lightning2Top),
            lightning2.pinRight(to: view, Numbers.lightning2Right),
            lightningAnimation1.pinTop(to: view.topAnchor, Numbers.lightningAnimation1Top),
            lightningAnimation1.pinLeft(to: view, Numbers.lightningAnimation1Left),
            lightningAnimation2.pinTop(to: view.topAnchor, Numbers.lightningAnimation2Top),
            lightningAnimation2.pinRight(to: view, Numbers.lightningAnimation2Right),
            challengeCat.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Numbers.challengeCatsTop),
            challengeCat.pinLeft(to: view, Numbers.challengeCatsLeft),
            challengeMice.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Numbers.challengeMiceTop),
            challengeMice.pinRight(to: view, Numbers.challengeMiceRight),
            challengeCalendar.pinCenterX(to: view),
            challengeCalendar.pinTop(to: challengeCat.bottomAnchor, 35),
            challengeCrownsButton.pinCenterX(to: view),
            challengeCrownsButton.pinTop(to: challengeCalendar.bottomAnchor, 35),
            challengeSudokuButton.pinCenterX(to: view),
            challengeSudokuButton.pinTop(to: challengeCrownsButton.bottomAnchor, 15)
        ])
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
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 3...5), repeats: true) { _ in
            self.challengeCat.startBlinking()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
