//
//  UnfinishedCrownsView.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import UIKit

// MARK: - UnfinishedCrownsViewControllerDelegate protocol
protocol UnfinishedCrownsViewControllerDelegate: AnyObject {
    func unfinishedCrownsDidRequestToContinue(with foundation: CrownsPlayModel.BuildModule.BuildFoundation)
}

// MARK: - UnfinishedCrownsViewController class
final class UnfinishedCrownsViewController: UIViewController {
    // MARK: - Properties
    private let interactor: UnfinishedCrownsBusinessLogic
    weak var delegate: UnfinishedCrownsViewControllerDelegate?
    
    private let dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.black.withAlphaComponent(Constants.overlayAlpha)
        return view
    }()
    private let backButton: UIButton = CustomButton(button: UIImageView(image: UIImage.backButton),
                                                    tapped: UIImageView(image: UIImage.backButtonTap))
    private let continueView: UIView = UIView()
    private let logo: CustomText = CustomText(text: Constants.unfinishedCrowns, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let descriptionStack = UIStackView()
    private let continueButton: UIButton = CustomButton(button: UIImageView(image: UIImage.button))
    
    // MARK: - Lifecycle
    init(interactor: UnfinishedCrownsBusinessLogic) {
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
    func configureDescription(_ viewModel: UnfinishedCrownsModel.AddDescription.ViewModel) {
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
        interactor.getDescriptionParametrs(UnfinishedCrownsModel.AddDescription.Request())
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
        interactor.deleteProgress(UnfinishedCrownsModel.DeleteProgress.Request())
    }
    
    @objc func continueButtonTapped() {
        dismiss(animated: false) {
            self.delegate?.unfinishedCrownsDidRequestToContinue(with: self.interactor.getCrownsFoundation())
        }
        interactor.deleteProgress(UnfinishedCrownsModel.DeleteProgress.Request())
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
        static let unfinishedCrowns: String = "You have one unfinished crowns game"
        static let continueButtonText: String = "Continue the game"
        
        static var logoTextSize: CGFloat { 25 * Layout.scaleH }
        static var continueViewHeight: CGFloat { 310 * Layout.scaleH }
        static var continueViewLogoWidth: CGFloat { 280 * Layout.scaleW }
        static var descriptionTextSize: CGFloat { 20 * Layout.scaleH }
        static var continueViewStackSpacing: CGFloat { 8 * Layout.scaleH }
        static let buttonTextSize: CGFloat = 20
        
        static var logoTop: CGFloat { 15 * Layout.scaleH }
        static var backButtonLeft: CGFloat { 15 * Layout.scaleW }
        static var descriptionTop: CGFloat { 20 * Layout.scaleH }
        static var descriptionLeft: CGFloat { 20 * Layout.scaleW }
        static var catBottom: CGFloat { 10 * Layout.scaleH }
        static var catRight: CGFloat { 20 * Layout.scaleW }
        static var continueButtonY: CGFloat { -4 * Layout.scaleH }
        static var continueButtonBottom: CGFloat { 20 * Layout.scaleH }
        
        static let overlayAlpha = 0.3
        static var continueViewRadius: CGFloat { 25 * Layout.scaleH }
        
    }
}


