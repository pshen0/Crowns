//
//  ProfileViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private let interactor: ProfileBusinessLogic
    
    private let profileLogoText = CustomText(text: Text.profileLogo, fontSize: Constraints.profileLogoSize, textColor: Colors.white)
    private let nameTextField = NameTextField()
    private let statisticsButton: UIButton = CustomButton(button: UIImageView(image: Images.statisticsButton))
    private let developerButton: UIButton = CustomButton(button: UIImageView(image: Images.developerButton))
    private let profileButtonStack: UIStackView = UIStackView()
    
    private let avatarImageField: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.startAvatarPicture
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setWidth(Constraints.imageViewSize)
        imageView.setHeight(Constraints.imageViewSize)
        imageView.layer.cornerRadius = Constraints.imageViewRadius
        return imageView
    }()
    
    private let changeAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Text.changeAvatarButtonText, for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Text.fontIrishGrover, size: Constraints.changeAvatarButtonTextSize)
        return button
    }()
    
    init(interactor: ProfileBusinessLogic) {
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
        view.backgroundColor = Colors.darkGray
        configureProfile()
        interactor.loadProfileData(ProfileModel.LoadProfile.Request())
        configureButtonStack()
    }
    
    private func configureProfile() {
        for subview in [profileLogoText, nameTextField, avatarImageField, changeAvatarButton] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        profileLogoText.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.profileLogoTextTop)
        avatarImageField.pinTop(to: profileLogoText.bottomAnchor, Constraints.avatarImageFieldTop)
        changeAvatarButton.pinTop(to: avatarImageField.bottomAnchor, Constraints.changeAvatarButtonTop)
        nameTextField.pinTop(to: changeAvatarButton.bottomAnchor, Constraints.nameTextFieldTop)
        nameTextField.setWidth(Constraints.nameTextFieldWidth)
        
        changeAvatarButton.addTarget(self, action: #selector(selectAvatar), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingDidEnd)
    }
    
    func loadProfile(_ viewModel: ProfileModel.LoadProfile.ViewModel) {
        nameTextField.text = viewModel.name
        avatarImageField.image = viewModel.avatar
    }
    
    private func configureButtonStack() {
        profileButtonStack.axis = .vertical
        profileButtonStack.spacing = Constraints.profileButtonStackSpacing
        profileButtonStack.alignment = .center
        
        for button in [statisticsButton, developerButton] {
            profileButtonStack.addArrangedSubview(button)
        }
        
        view.addSubview(profileButtonStack)
        
        profileButtonStack.pinCenterX(to: view)
        profileButtonStack.pinTop(to: nameTextField.bottomAnchor, Constraints.profileButtonStackTop)
        
        statisticsButton.addTarget(self, action: #selector(statisticsButtonTapped), for: .touchUpInside)
        developerButton.addTarget(self, action: #selector(developerButtonTapped), for: .touchUpInside)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            avatarImageField.image = selectedImage
            interactor.saveProfileData(ProfileModel.SaveProfile.Request(name: nameTextField.text, avatar: avatarImageField.image))
        }
        picker.dismiss(animated: true)
    }
    
    @objc private func selectAvatar() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc private func nameChanged() {
        interactor.saveProfileData(ProfileModel.SaveProfile.Request(name: nameTextField.text, avatar: avatarImageField.image))
    }
    
    @objc private func statisticsButtonTapped() {
        interactor.statisticsButtonTapped(ProfileModel.RouteStatistics.Request())
    }
    
    @objc private func developerButtonTapped() {
        interactor.developerButtonTapped(ProfileModel.RouteDeveloper.Request())
    }
}
