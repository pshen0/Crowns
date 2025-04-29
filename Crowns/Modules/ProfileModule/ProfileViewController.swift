//
//  ProfileViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

// MARK: - ProfileViewController class
final class ProfileViewController: UIViewController {
    // MARK: - Properties
    private let interactor: ProfileBusinessLogic
    
    private let logoText = CustomText(text: Constants.logoText, fontSize: Constants.logoSize, textColor: Colors.white)
    private let nameField = NameTextField()
    private let statisticsButton: UIButton = CustomButton(button: UIImageView(image: UIImage.statisticsButton))
    private let developerButton: UIButton = CustomButton(button: UIImageView(image: UIImage.developerButton))
    private let buttonStack: UIStackView = UIStackView()
    
    private let avatarField: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.startAvatar
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setWidth(Constants.avatarSize)
        imageView.setHeight(Constants.avatarSize)
        imageView.layer.cornerRadius = Constants.avatarRadius
        return imageView
    }()
    
    private let changeAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.avatarButtonText, for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.IrishGrover, size: Constants.avatarButtonTextSize)
        return button
    }()
    
    // MARK: - Lifecycle
    init(interactor: ProfileBusinessLogic) {
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
    func loadProfile(_ viewModel: ProfileModel.LoadProfile.ViewModel) {
        nameField.text = viewModel.name
        avatarField.image = viewModel.avatar
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        view.backgroundColor = Colors.darkGray
        configureProfile()
        interactor.loadProfileData(ProfileModel.LoadProfile.Request())
        configureButtonStack()
    }
    
    private func configureProfile() {
        for subview in [logoText, nameField, avatarField, changeAvatarButton] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        logoText.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.logoTextTop)
        avatarField.pinTop(to: logoText.bottomAnchor, Constants.avatarFieldTop)
        changeAvatarButton.pinTop(to: avatarField.bottomAnchor, Constants.avatarButtonTop)
        nameField.pinTop(to: changeAvatarButton.bottomAnchor, Constants.nameFieldTop)
        nameField.setWidth(Constants.nameFieldWidth)
        
        changeAvatarButton.addTarget(self, action: #selector(selectAvatar), for: .touchUpInside)
        nameField.addTarget(self, action: #selector(nameChanged), for: .editingDidEnd)
    }
    
    private func configureButtonStack() {
        buttonStack.axis = .vertical
        buttonStack.spacing = Constants.buttonStackSpacing
        buttonStack.alignment = .center
        
        for button in [statisticsButton, developerButton] {
            buttonStack.addArrangedSubview(button)
        }
        
        view.addSubview(buttonStack)
        
        buttonStack.pinCenterX(to: view)
        buttonStack.pinTop(to: nameField.bottomAnchor, Constants.buttonStackTop)
        
        statisticsButton.addTarget(self, action: #selector(statisticsButtonTapped), for: .touchUpInside)
        developerButton.addTarget(self, action: #selector(developerButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func selectAvatar() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc private func nameChanged() {
        interactor.saveProfileData(ProfileModel.SaveProfile.Request(name: nameField.text, avatar: avatarField.image))
    }
    
    @objc private func statisticsButtonTapped() {
        interactor.statisticsButtonTapped(ProfileModel.RouteStatistics.Request())
    }
    
    @objc private func developerButtonTapped() {
        interactor.developerButtonTapped(ProfileModel.RouteDeveloper.Request())
    }
    
    // MARK: - Constants
    private enum Constants {
        static let logoText: String = "Profile"
        static let avatarButtonText: String = "Choose photo"
        
        static let logoTextTop: CGFloat = 5
        static let avatarFieldTop: CGFloat = 20
        static let avatarButtonTop: CGFloat = 10
        static let nameFieldTop: CGFloat = 10
        static let buttonStackTop: CGFloat = 100
        
        static let logoSize: CGFloat = 35
        static let avatarSize: CGFloat = 100
        static let avatarButtonTextSize = 17.0
        static let nameFieldWidth: CGFloat = 200
        static let buttonStackSpacing: CGFloat = 15
        
        
        static let avatarRadius: CGFloat = 50
    }
}

// MARK: - Extensions
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            avatarField.image = selectedImage
            interactor.saveProfileData(ProfileModel.SaveProfile.Request(name: nameField.text, avatar: avatarField.image))
        }
        picker.dismiss(animated: true)
    }
}
