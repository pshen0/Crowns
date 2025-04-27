import UIKit

final class DeveloperViewController: UIViewController {
    
    let interactor: DeveloperBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                      tapped: UIImageView(image: Images.backButtonTap))
    private let developerLogo = CustomText(text: "About the developer", fontSize: 35, textColor: Colors.white)
    private let developerCat = JumpingCatView(duration: 0.9, repeatCount: 1)
    private let descriptionText = CustomText(text:
    """
    Hi, my name is Anna:) I developed this app as a coursework at the HSE University.
    Below are the contacts you can use to contact me, and a link to the project.
    """, fontSize: 20, textColor: Colors.white)
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
        fatalError("init(coder:) has not been implemented")
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
        view.addSubview(developerLogo)
        developerLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 50)
        developerLogo.pinCenterX(to: view)
    }
    
    private func configureDeveloperImage() {
        view.addSubview(developerCat)
        developerCat.pinTop(to: developerLogo.bottomAnchor, 10)
        developerCat.pinCenterX(to: view)
    }
    
    private func configureDescriptionText() {
        descriptionText.numberOfLines = 0
        descriptionText.lineBreakMode = .byWordWrapping
        view.addSubview(descriptionText)
        descriptionText.pinLeft(to: view.leadingAnchor, 10)
        descriptionText.pinRight(to: view.trailingAnchor, 10)
        descriptionText.pinTop(to: developerCat.bottomAnchor, 10)
    }
    
    private func configureButtons() {
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = 70
        
        for subview in [mailButton, telegramButton, githubButton] {
            buttonStack.addArrangedSubview(subview)
            subview.pinCenterY(to: buttonStack)
        }
        
        view.addSubview(buttonStack)
        buttonStack.pinTop(to: descriptionText.bottomAnchor, 40)
        buttonStack.pinCenterX(to: view)
        
        mailButton.addTarget(self, action: #selector(mailButtonTapped), for: .touchUpInside)
        githubButton.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
        telegramButton.addTarget(self, action: #selector(telegramButtonTapped), for: .touchUpInside)
    }
    
    func startAnimateDeveloperScreen() {
        self.developerCat.startJumping()
        catTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            self.developerCat.startJumping()
        }
    }
    
    func stopAnimateDeveloperScreen() {
        developerCat.stopJumping()
        catTimer?.invalidate()
        catTimer = nil
    }
    
    @objc private func mailButtonTapped() {
        if let url = URL(string: "mailto:aasazonova_1@edu.hse.ru") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func githubButtonTapped() {
        if let url = URL(string: "https://github.com/pshen0/Crowns") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func telegramButtonTapped() {
        if let url = URL(string: "https://t.me/anya_psheno") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(DeveloperModel.RouteBack.Request())
    }
}
