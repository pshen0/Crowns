//
//  GameSelector.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit

final class GameSelector: UIViewController {
    let chooseCrownsButton: UIButton = CustomButton(button: UIImageView(image: Images.chooseCrownsButton))
    let chooseSudokuButton: UIButton = CustomButton(button: UIImageView(image: Images.chooseSudokuButton))
    let chooseQueensButton: UIButton = CustomButton(button: UIImageView(image: Images.chooseQueensButton))
    private let dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(Numbers.gameSelectorOverlay)
        return view
    }()
    private let gameSelectorView: UIView = UIView()
    private let gameSelectorButtonsStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constraints.gameSelectorButtonsStackSpacing
        return stack
    }()
    private var selectorText: CustomText = CustomText(text: "", fontSize: Constraints.selectorTextSize, textColor: Colors.white)
    
    init(logo: CustomText) {
        self.selectorText = logo
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
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
        gameSelectorView.layer.cornerRadius = Constraints.gameSelectorRadius
        
        view.addSubview(gameSelectorView)
        gameSelectorView.addSubview(selectorText)
        
        gameSelectorView.setWidth(view.frame.width)
        gameSelectorView.setHeight(Constraints.gameSelectorHeight)
        gameSelectorView.pinBottom(to: view.bottomAnchor)
        selectorText.pinCenterX(to: gameSelectorView)
        selectorText.pinTop(to: gameSelectorView.topAnchor, Constraints.chooseTextTop)
    }
    
    private func configureButtonsStack() {
        for button in [chooseCrownsButton, chooseSudokuButton, chooseQueensButton] {
            gameSelectorButtonsStack.addArrangedSubview(button)
        }
        
        gameSelectorView.addSubview(gameSelectorButtonsStack)
        
        gameSelectorButtonsStack.pinCenterX(to: gameSelectorView)
        gameSelectorButtonsStack.pinTop(to: selectorText.bottomAnchor, Constraints.gameSelectorButtonsStackTop)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false)
    }
}



