//
//  UnfinishedCrownsView.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import UIKit

protocol UnfinishedCrownsViewControllerDelegate: AnyObject {
    func unfinishedCrownsDidRequestToContinue(with foundation: CrownsPlayModel.BuildModule.BuildFoundation)
}

final class UnfinishedCrownsViewController: UIViewController {
    
    private let interactor: UnfinishedCrownsBusinessLogic
    weak var delegate: UnfinishedCrownsViewControllerDelegate?
    
    private let dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(Numbers.gameSelectorOverlay)
        return view
    }()
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                      tapped: UIImageView(image: Images.backButtonTap))
    private let continueView: UIView = UIView()
    private let viewLogo: CustomText = CustomText(text: Text.unfinishedCrowns, fontSize: Constraints.selectorTextSize, textColor: Colors.white)
    private let descriptionStack = UIStackView()
    private let continueButton: UIButton = CustomButton(button: UIImageView(image: UIImage.button))
    
    init(interactor: UnfinishedCrownsBusinessLogic) {
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
        continueView.layer.cornerRadius = Constraints.gameSelectorRadius
        viewLogo.numberOfLines = 0
        viewLogo.lineBreakMode = .byWordWrapping
        
        view.addSubview(continueView)
        view.addSubview(viewLogo)
        view.addSubview(backButton)
        
        continueView.setWidth(view.frame.width)
        continueView.setHeight(Constraints.gameSelectorHeight)
        continueView.pinBottom(to: view.bottomAnchor)
        viewLogo.pinCenterX(to: continueView)
        viewLogo.pinTop(to: continueView.topAnchor, Constraints.unfinishedViewLogoTop)
        viewLogo.setWidth(Constraints.unfinishedViewLogoWidth)
        backButton.pinTop(to: continueView.topAnchor, Constraints.unfinishedViewLogoTop)
        backButton.pinLeft(to: view.leadingAnchor, 15)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    func configureDescription(_ viewModel: UnfinishedCrownsModel.AddDescription.ViewModel) {
        let difficultyLabel = CustomText(text: viewModel.difficultyLabel, fontSize: Constraints.descriptionTextSize, textColor: Colors.white)
        let timeLabel = CustomText(text: viewModel.timeLabel, fontSize: Constraints.descriptionTextSize, textColor: Colors.white)
        let catImage: UIImageView = UIImageView(image: Images.smallCat)
        
        descriptionStack.axis = .vertical
        descriptionStack.alignment = .leading
        descriptionStack.spacing = Constraints.unfinishedViewStackSpacing
        
        for subview in [difficultyLabel, timeLabel] {
            descriptionStack.addArrangedSubview(subview)
        }
        
        view.addSubview(descriptionStack)
        view.addSubview(catImage)
        
        descriptionStack.pinTop(to: viewLogo.bottomAnchor, Constraints.descriptionUnfinishedTop)
        descriptionStack.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constraints.descriptionUnfinishedL)
        catImage.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constraints.descriptionUnfinishedL)
        catImage.pinBottom(to: timeLabel.bottomAnchor, 10)
    }
    
    private func configureButton() {
        let continueButtonText = CustomText(text: Text.continueGameText, fontSize: Constraints.selectorTextSize, textColor: Colors.white)
        
        continueButton.addSubview(continueButtonText)
        view.addSubview(continueButton)
        
        continueButtonText.pinCenterX(to: continueButton)
        continueButtonText.pinCenterY(to: continueButton, -4)
        continueButton.pinCenterX(to: view)
        continueButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constraints.descriptionUnfinishedTop)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
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
}


