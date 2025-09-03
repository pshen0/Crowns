//
//  SudokuLearningViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 02.02.2025.
//

import UIKit

// MARK: - SudokuLearningViewController class
final class SudokuLearningViewController: UIViewController {
    
    // MARK: - Properties
    private let backButton: UIButton = CustomButton(button: UIImageView(image: UIImage.backButton),
                                                      tapped: UIImageView(image: UIImage.backButtonTap))
    
    private let interactor: SudokuLearningBusinessLogic
    private var ruleViews: [UIImageView] = []
    private var catViews: [UIImageView] = []
    let ruleStack: UIStackView = UIStackView()
    private var currentIndex = 0
    private let nextButton: UIButton = CustomButton(button: UIImageView(image: UIImage.nextButton),
                                                    tapped: UIImageView(image: UIImage.nextButtonTap))
    
    // MARK: - Lifecycle
    init(interactor: SudokuLearningBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
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
    
    // MARK: - Funcs
    func systemTouchNextButton() {
        nextButton.sendActions(for: .touchUpInside)
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        configureBackground()
        configureImages()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let lBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = lBarButtonItem

        view.addSubview(nextButton)
        
        nextButton.pinCenterX(to: view)
        nextButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.nextButtonBottom)
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    private func configureImages() {
        let imageNames = Constants.ruleImageNames
        ruleStack.axis = .vertical
        ruleStack.alignment = .center
        ruleStack.spacing = Constants.ruleStackSpacing
        view.addSubview(ruleStack)
        
        for name in imageNames {
            let imageView = UIImageView(image: UIImage(named: name))
            let catView = UIImageView(image: UIImage.ruleCat)
            imageView.contentMode = .scaleAspectFit
            imageView.alpha = Constants.invisibleAlpha
            catView.contentMode = .scaleAspectFit
            catView.alpha = Constants.invisibleAlpha
            ruleStack.addArrangedSubview(imageView)
            view.addSubview(catView)
            
            catView.pinCenterY(to: imageView)
            catView.pinLeft(to: imageView.trailingAnchor)
            imageView.setHeight(imageView.bounds.height * Layout.scaleH)
        
            ruleViews.append(imageView)
            catViews.append(catView)
        }
        
        ruleStack.pinCenter(to: view)
        
        if let first = ruleViews.first, let cat = catViews.first {
            first.alpha = Constants.visibleAlpha
            cat.alpha = Constants.visibleAlpha
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(SudokuLearningModel.RouteBack.Request())
    }
    
    @objc private func nextTapped() {
        let nextImage = ruleViews[currentIndex + 1]
        let currentCat = catViews[currentIndex]
        let nextCat = catViews[currentIndex + 1]
        

        UIView.transition(with: nextImage, duration: Constants.duration, options: .transitionCrossDissolve, animations: {
            nextImage.alpha = Constants.visibleAlpha
        }, completion: nil)
        
        UIView.transition(with: currentCat, duration: Constants.duration, options: .transitionCrossDissolve, animations: {
            currentCat.alpha = Constants.invisibleAlpha
        }, completion: nil)
        
        if currentIndex < Constants.secondLastIndex {
            UIView.transition(with: nextCat, duration: Constants.duration, options: .transitionCrossDissolve, animations: {
                nextCat.alpha = Constants.visibleAlpha
            }, completion: nil)
        }

        currentIndex += 1
        guard currentIndex < ruleViews.count - 1 else {
            nextButton.isHidden = true
            return
        }
    }
    
    private enum Layout {
        static let screenHeight = UIScreen.main.bounds.height
        static let screenWidth = UIScreen.main.bounds.width
        
        static let baseHeight: CGFloat = 844
        static let baseWidth: CGFloat = 390
        
        static var scaleH: CGFloat { screenHeight / baseHeight }
        static var scaleW: CGFloat { screenWidth / baseWidth }
    }
    
    // MARK: - Constants
    private enum Constants {
        static var ruleStackSpacing: CGFloat { 10.0 * Layout.scaleH }
        static var nextButtonBottom: CGFloat { 5.0 * Layout.scaleH }
        
        static let visibleAlpha = 1.0
        static let invisibleAlpha = 0.0
        static let duration = 0.4
        static let secondLastIndex = 2
        
        static let ruleImageNames = ["sudokuRule1", "sudokuRule2", "sudokuRule3", "sudokuRule4"]
    }
}
