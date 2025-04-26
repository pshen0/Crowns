//
//  SudokuLearningViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 02.02.2025.
//

import UIKit

final class SudokuLearningViewController: UIViewController {
    
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                      tapped: UIImageView(image: Images.backButtonTap))
    
    private let interactor: SudokuLearningBusinessLogic
    private var imageViews: [UIImageView] = []
    private var catViews: [UIImageView] = []
    let imagesStack: UIStackView = UIStackView()
    private var currentIndex = 0
    private let nextButton: UIButton = CustomButton(button: UIImageView(image: Images.nextButton),
                                                    tapped: UIImageView(image: Images.nextButtonTap))
    
    init(interactor: SudokuLearningBusinessLogic) {
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
        nextButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 5)
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    private func configureImages() {
        let imageNames = ["sudokuRule1", "sudokuRule2", "sudokuRule3", "sudokuRule4"]
        imagesStack.axis = .vertical
        imagesStack.alignment = .center
        imagesStack.spacing = 10
        view.addSubview(imagesStack)
        
        for name in imageNames {
            let imageView = UIImageView(image: UIImage(named: name))
            let catView = UIImageView(image: UIImage(named: "ruleCat"))
            imageView.contentMode = .scaleAspectFit
            imageView.alpha = 0
            catView.contentMode = .scaleAspectFit
            catView.alpha = 0
            imagesStack.addArrangedSubview(imageView)
            view.addSubview(catView)
            
            catView.pinCenterY(to: imageView)
            catView.pinLeft(to: imageView.trailingAnchor)
        
            imageViews.append(imageView)
            catViews.append(catView)
        }
        
        imagesStack.pinCenter(to: view)
        
        if let first = imageViews.first, let cat = catViews.first {
            first.alpha = 1
            cat.alpha = 1
        }
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(SudokuLearningModel.RouteBack.Request())
    }
    
    @objc private func nextTapped() {
        let nextImage = imageViews[currentIndex + 1]
        let currentCat = catViews[currentIndex]
        let nextCat = catViews[currentIndex + 1]
        

        UIView.transition(with: nextImage, duration: 0.4, options: .transitionCrossDissolve, animations: {
            nextImage.alpha = 1
        }, completion: nil)
        
        UIView.transition(with: currentCat, duration: 0.4, options: .transitionCrossDissolve, animations: {
            currentCat.alpha = 0
        }, completion: nil)
        
        if currentIndex < 2 {
            UIView.transition(with: nextCat, duration: 0.4, options: .transitionCrossDissolve, animations: {
                nextCat.alpha = 1
            }, completion: nil)
        }

        currentIndex += 1
        guard currentIndex < imageViews.count - 1 else {
            nextButton.isHidden = true
            return
        }
    }
    
    func systemTouchNextButton() {
        nextButton.sendActions(for: .touchUpInside)
    }
}
