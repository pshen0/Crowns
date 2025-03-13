//
//  SudokuGameOverViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import UIKit

final class SudokuGameOverViewController: UIViewController {
    
    private let interactor: SudokuGameOverBusinessLogic
    private let gameLogo: UILabel = CustomText(text: Text.sudokuGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    private var gameResult: UILabel = UILabel()
    private let homeButton: UIButton = CustomButton(button: UIImageView(image: Images.gameOverHomeButton))
    
    var isWin: Bool = true
    
    init(interactor: SudokuGameOverBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        let resultText = isWin ? "Victory" : "Defeat"
        gameResult = CustomText(text: resultText, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configureBackground()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        
        for subview in [gameLogo, gameResult, homeButton] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        gameResult.pinTop(to: gameLogo.bottomAnchor, 20)
        homeButton.pinCenterY(to: view)
        
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func homeButtonTapped() {
        interactor.homeButtonTapped(SudokuGameOverModel.RouteHome.Request())
    }
}
