//
//  GameSelector.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit

// MARK: - GameSelector class
final class GameSelector: UIViewController {
    
    // MARK: - Properties
    let chooseCrownsButton: UIButton = CustomButton(button: UIImageView(image: UIImage.chooseCrownsButton))
    let chooseSudokuButton: UIButton = CustomButton(button: UIImageView(image: UIImage.chooseSudokuButton))
    private let dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.overlayAlpha)
        return view
    }()
    private let gameSelectorView: UIView = UIView()
    private let gameSelectorButtonsStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constants.gameSelectorButtonsStackSpacing
        return stack
    }()
    private var selectorText: CustomText = CustomText(text: "", fontSize: Constants.selectorTextSize, textColor: Colors.white)
    
    // MARK: - Lifecycle
    init(logo: CustomText) {
        self.selectorText = logo
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
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
    
    // MARK: - Private funcs
    private func configureUI() {
        view.backgroundColor = .clear
        view.clipsToBounds = false
        dismissView.frame = view.bounds
        dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelf)))
        
        view.addSubview(dismissView)
        
        configureBackground()
        configureButtonsStack()
    }
    
    private func configureBackground() {
        gameSelectorView.backgroundColor = Colors.darkGray
        gameSelectorView.layer.cornerRadius = Constants.gameSelectorRadius
        
        view.addSubview(gameSelectorView)
        gameSelectorView.addSubview(selectorText)
        
        gameSelectorView.setWidth(view.frame.width)
        gameSelectorView.setHeight(Constants.gameSelectorHeight)
        gameSelectorView.pinBottom(to: view.bottomAnchor)
        selectorText.pinCenterX(to: gameSelectorView)
        selectorText.pinTop(to: gameSelectorView.topAnchor, Constants.chooseTextTop)
    }
    
    private func configureButtonsStack() {
        for button in [chooseCrownsButton, chooseSudokuButton] {
            gameSelectorButtonsStack.addArrangedSubview(button)
        }
        
        gameSelectorView.addSubview(gameSelectorButtonsStack)
        
        gameSelectorButtonsStack.pinCenterX(to: gameSelectorView)
        gameSelectorButtonsStack.pinTop(to: selectorText.bottomAnchor, Constants.gameSelectorButtonsStackTop)
    }
    
    // MARK: - Actions
    @objc private func dismissSelf() {
        dismiss(animated: false)
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
        static var selectorTextSize: CGFloat { 25 * Layout.scaleH }
        static var gameSelectorHeight: CGFloat { 310 * Layout.scaleH }
        
        static var chooseTextTop: CGFloat { 30 * Layout.scaleH }
        
        static let gameSelectorRadius: CGFloat = 16
        static let overlayAlpha = 0.3
        static var gameSelectorButtonsStackSpacing: CGFloat { 15 * Layout.scaleH }
        static var gameSelectorButtonsStackTop: CGFloat { 30 * Layout.scaleH }
    }
}
