//
//  GameSelector.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit

final class GameSelector: UIViewController {
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
    
    @objc private func dismissSelf() {
        dismiss(animated: false)
    }
    
    private enum Constants {
        static let selectorTextSize: CGFloat = 25
        static let gameSelectorHeight: CGFloat = 310
        
        static let chooseTextTop: CGFloat = 30
        
        static let gameSelectorRadius: CGFloat = 16
        static let overlayAlpha = 0.3
        static let gameSelectorButtonsStackSpacing: CGFloat = 15
        static let gameSelectorButtonsStackTop: CGFloat = 30
    }
}



