//
//  UnfinishedCrownsView.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import UIKit

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
    private let discriptionStack = UIStackView()
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
        interactor.getDiscriptionParametrs(UnfinishedCrownsModel.AddDiscription.Request())
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
    
    func configureDiscription(_ viewModel: UnfinishedCrownsModel.AddDiscription.ViewModel) {
        let difficultyLabel = CustomText(text: viewModel.difficultyLabel, fontSize: Constraints.discriptionTextSize, textColor: Colors.white)
        let timeLabel = CustomText(text: viewModel.timeLabel, fontSize: Constraints.discriptionTextSize, textColor: Colors.white)
        let catImage: UIImageView = UIImageView(image: Images.smallCat)
        
        discriptionStack.axis = .vertical
        discriptionStack.alignment = .leading
        discriptionStack.spacing = Constraints.unfinishedViewStackSpacing
        
        for subview in [difficultyLabel, timeLabel] {
            discriptionStack.addArrangedSubview(subview)
        }
        
        view.addSubview(discriptionStack)
        view.addSubview(catImage)
        
        discriptionStack.pinTop(to: viewLogo.bottomAnchor, Constraints.discriptionUnfinishedCrownsTop)
        discriptionStack.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, Constraints.discriptionUnfinishedCrownsL)
        catImage.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constraints.discriptionUnfinishedCrownsL)
        catImage.pinBottom(to: timeLabel.bottomAnchor, 10)
    }
    
    private func configureButton() {
        let continueButtonText = CustomText(text: Text.continueGameText, fontSize: Constraints.selectorTextSize, textColor: Colors.white)
        
        continueButton.addSubview(continueButtonText)
        view.addSubview(continueButton)
        
        continueButtonText.pinCenterX(to: continueButton)
        continueButtonText.pinCenterY(to: continueButton, -4)
        continueButton.pinCenterX(to: view)
        continueButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constraints.discriptionUnfinishedCrownsTop)
        
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

protocol UnfinishedCrownsViewControllerDelegate: AnyObject {
    func unfinishedCrownsDidRequestToContinue(with foundation: CrownsPlayModel.BuildModule.BuildFoundation)
}


