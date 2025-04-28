import UIKit

final class DeveloperViewController: UIViewController {
    
    let interactor: DeveloperBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: UIImage.backButton),
                                                      tapped: UIImageView(image: UIImage.backButtonTap))
    private let logo = CustomText(text: Constants.logoText, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let developerCat = JumpingCatView(duration: Constants.catDuration, repeatCount: Constants.catRepeat)
    private let descriptionText = CustomText(text: Constants.descriptionText, fontSize: Constants.descriptionTextSize, textColor: Colors.white)
    private let mailButton: UIButton = CustomButton(button: UIImageView(image: UIImage.mail))
    private let telegramButton: UIButton = CustomButton(button: UIImageView(image: UIImage.telegram))
    private let githubButton: UIButton = CustomButton(button: UIImageView(image: UIImage.github))
    private let buttonStack = UIStackView()
    private var catTimer: Timer?
    
    init(interactor: DeveloperBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Errors.initErrorCoder)
    }
    
    deinit {
        catTimer?.invalidate()
        catTimer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        
        startAnimateDeveloperScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        stopAnimateDeveloperScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let lBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = lBarButtonItem
        
        configureLogo()
        configureDeveloperImage()
        configureDescriptionText()
        configureButtons()
    }
    
    private func configureLogo() {
        view.addSubview(logo)
        logo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.logoTop)
        logo.pinCenterX(to: view)
    }
    
    private func configureDeveloperImage() {
        view.addSubview(developerCat)
        developerCat.pinTop(to: logo.bottomAnchor, Constants.catTop)
        developerCat.pinCenterX(to: view)
    }
    
    private func configureDescriptionText() {
        descriptionText.numberOfLines = 0
        descriptionText.lineBreakMode = .byWordWrapping
        view.addSubview(descriptionText)
        descriptionText.pinLeft(to: view.leadingAnchor, Constants.descriptionLeft)
        descriptionText.pinRight(to: view.trailingAnchor, Constants.descriptionRight)
        descriptionText.pinTop(to: developerCat.bottomAnchor, Constants.descriptionTop)
    }
    
    private func configureButtons() {
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = Constants.buttonStackSpacing
        
        for subview in [mailButton, telegramButton, githubButton] {
            buttonStack.addArrangedSubview(subview)
            subview.pinCenterY(to: buttonStack)
        }
        
        view.addSubview(buttonStack)
        buttonStack.pinTop(to: descriptionText.bottomAnchor, Constants.buttonStackTop)
        buttonStack.pinCenterX(to: view)
        
        mailButton.addTarget(self, action: #selector(mailButtonTapped), for: .touchUpInside)
        githubButton.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
        telegramButton.addTarget(self, action: #selector(telegramButtonTapped), for: .touchUpInside)
    }
    
    func startAnimateDeveloperScreen() {
        self.developerCat.startJumping()
        catTimer = Timer.scheduledTimer(withTimeInterval: Constants.catAnimationInterval, repeats: true) { _ in
            self.developerCat.startJumping()
        }
    }
    
    func stopAnimateDeveloperScreen() {
        developerCat.stopJumping()
        catTimer?.invalidate()
        catTimer = nil
    }
    
    @objc private func mailButtonTapped() {
        if let url = URL(string: Constants.mailURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func githubButtonTapped() {
        if let url = URL(string: Constants.githubURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func telegramButtonTapped() {
        if let url = URL(string: Constants.tgURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(DeveloperModel.RouteBack.Request())
    }
    
    private enum Constants {
        static let logoText = "About the developer"
        static let descriptionText =
            """
            Hi, my name is Anna:) I developed this app as a coursework at the HSE University.
            Below are the contacts you can use to contact me, and a link to the project.
            """
        static let mailURL = "mailto:aasazonova_1@edu.hse.ru"
        static let githubURL = "https://github.com/pshen0/Crowns"
        static let tgURL = "https://t.me/anya_psheno"
        
        static let logoTextSize = 35.0
        static let descriptionTextSize = 20.0
        static let buttonStackSpacing = 70.0
        
        static let logoTop = 50.0
        static let catTop = 10.0
        static let descriptionLeft = 10.0
        static let descriptionRight = 10.0
        static let descriptionTop = 10.0
        static let buttonStackTop = 40.0
        
        static let catDuration = 0.9
        static let catRepeat = 1
        static let catAnimationInterval = 2.0
    }
}
