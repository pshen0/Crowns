//
//  UnfinishedSudokuView.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import UIKit

// MARK: - UnfinishedSudokuViewControllerDelegate protocol
protocol UnfinishedSudokuViewControllerDelegate: AnyObject {
    func unfinishedSudokuDidRequestToContinue(with foundation: SudokuPlayModel.BuildModule.BuildFoundation)
}

// MARK: - UnfinishedSudokuViewController class
final class UnfinishedSudokuViewController: UIViewController {
    
    // MARK: - Properties
    private let interactor: UnfinishedSudokuBusinessLogic
    weak var delegate: UnfinishedSudokuViewControllerDelegate?
    
    private let dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.overlayAlpha)
        return view
    }()
    private let backButton: UIButton = CustomButton(button: UIImageView(image: UIImage.backButton),
                                                      tapped: UIImageView(image: UIImage.backButtonTap))
    private let continueView: UIView = UIView()
    private let logo: CustomText = CustomText(text: Constants.unfinishedSudoku, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let descriptionStack = UIStackView()
    private let continueButton: UIButton = CustomButton(button: UIImageView(image: UIImage.button))
    
    // MARK: - Lifecycle
    init(interactor: UnfinishedSudokuBusinessLogic) {
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
    
    // MARK: - Funcs
    func configureDescription(_ viewModel: UnfinishedSudokuModel.AddDescription.ViewModel) {
        let difficultyLabel = CustomText(text: viewModel.difficultyLabel, fontSize: Constants.descriptionTextSize, textColor: Colors.white)
        let timeLabel = CustomText(text: viewModel.timeLabel, fontSize: Constants.descriptionTextSize, textColor: Colors.white)
        let catImage: UIImageView = UIImageView(image: UIImage.smallCat)
        
        descriptionStack.axis = .vertical
        descriptionStack.alignment = .leading
        descriptionStack.spacing = Constants.continueViewStackSpacing
        
        for subview in [difficultyLabel, timeLabel] {
            descriptionStack.addArrangedSubview(subview)
        }
        
        view.addSubview(descriptionStack)
        view.addSubview(catImage)
        
        descriptionStack.pinTop(to: logo.bottomAnchor, Constants.descriptionTop)
        descriptionStack.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constants.descriptionLeft)
        catImage.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.catRight)
        catImage.pinBottom(to: timeLabel.bottomAnchor, Constants.catBottom)
    }

    // MARK: - Private funcs
    private func configureUI() {
        view.backgroundColor = .clear
        view.clipsToBounds = false
        dismissView.frame = view.bounds
        
        view.addSubview(dismissView)
        
        configureBackground()
        interactor.getDescriptionParametrs(UnfinishedSudokuModel.AddDescription.Request())
        configureButton()
    }
    
    private func configureBackground() {
        continueView.backgroundColor = Colors.darkGray
        continueView.layer.cornerRadius = Constants.continueViewRadius
        logo.numberOfLines = 0
        logo.lineBreakMode = .byWordWrapping
        
        view.addSubview(continueView)
        view.addSubview(logo)
        view.addSubview(backButton)
        
        continueView.setWidth(view.frame.width)
        continueView.setHeight(Constants.continueViewHeight)
        continueView.pinBottom(to: view.bottomAnchor)
        logo.pinCenterX(to: continueView)
        logo.pinTop(to: continueView.topAnchor, Constants.logoTop)
        logo.setWidth(Constants.continueViewLogoWidth)
        backButton.pinTop(to: continueView.topAnchor, Constants.logoTop)
        backButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeft)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func configureButton() {
        let continueButtonText = CustomText(text: Constants.continueButtonText, fontSize: Constants.buttonTextSize, textColor: Colors.white)
        
        continueButton.addSubview(continueButtonText)
        view.addSubview(continueButton)
        
        continueButtonText.pinCenterX(to: continueButton)
        continueButtonText.pinCenterY(to: continueButton, Constants.continueButtonY)
        continueButton.pinCenterX(to: view)
        continueButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.continueButtonBottom)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func backButtonTapped() {
        dismiss(animated: false)
        interactor.deleteProgress(UnfinishedSudokuModel.DeleteProgress.Request())
    }
    
    @objc func continueButtonTapped() {
        dismiss(animated: false) {
            self.delegate?.unfinishedSudokuDidRequestToContinue(with: self.interactor.getSudokuFoundation())
        }
        interactor.deleteProgress(UnfinishedSudokuModel.DeleteProgress.Request())
    }
    
    // MARK: - Constants
    private enum Constants {
        static let unfinishedSudoku: String = "You have one unfinished sudoku game"
        static let continueButtonText: String = "Continue the game"
        
        static let logoTextSize: CGFloat = 25
        static let continueViewHeight: CGFloat = 310
        static let continueViewLogoWidth: CGFloat = 280
        static let descriptionTextSize: CGFloat = 20
        static let continueViewStackSpacing: CGFloat = 8
        static let buttonTextSize: CGFloat = 20
        
        static let logoTop: CGFloat = 15
        static let backButtonLeft: CGFloat = 15
        static let descriptionTop: CGFloat = 20
        static let descriptionLeft: CGFloat = 20
        static let catBottom: CGFloat = 10
        static let catRight: CGFloat = 20
        static let continueButtonY: CGFloat = -4
        static let continueButtonBottom: CGFloat = 20
        
        static let overlayAlpha = 0.3
        static let continueViewRadius: CGFloat = 16
    }
}


