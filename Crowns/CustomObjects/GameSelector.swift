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
    private let buttonStack: UIView = UIView()
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
        
        configureButtonsStack()
        configureGameSelector()
        configureButtons()
    }
    
    private func configureButtonsStack() {
        buttonStack.backgroundColor = Colors.darkGray
        buttonStack.layer.cornerRadius = Constraints.gameSelectorRadius
        
        view.addSubview(buttonStack)
        
        buttonStack.setWidth(view.frame.width)
        buttonStack.setHeight(Constraints.gameSelectorHeight)
        buttonStack.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureGameSelector() {
        buttonStack.addSubview(selectorText)
        
        selectorText.pinCenterX(to: buttonStack)
        selectorText.pinTop(to: buttonStack.topAnchor, Constraints.chooseTextTop)
    }
    
    private func configureButtons() {
        for button in [chooseCrownsButton, chooseSudokuButton, chooseQueensButton] {
            buttonStack.addSubview(button)
            button.pinCenterX(to: buttonStack)
        }
        
        chooseCrownsButton.pinTop(to: selectorText.bottomAnchor, Constraints.chooseCrownsButtonTop)
        chooseSudokuButton.pinTop(to: chooseCrownsButton.bottomAnchor, Constraints.chooseSudokuButtonTop)
        chooseQueensButton.pinTop(to: chooseSudokuButton.bottomAnchor, Constraints.chooseQueensButtonTop)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false)
    }
}



