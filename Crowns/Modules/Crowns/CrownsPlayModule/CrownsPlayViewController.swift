//
//  CrownsPlayViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

// MARK: - CrownsPlayViewController class
final class CrownsPlayViewController: UIViewController{
    
    // MARK: - Properties
    private let interactor: CrownsPlayBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: UIImage.backButton),
                                                      tapped: UIImageView(image: UIImage.backButtonTap))
    private let undoButton: UIButton = CustomButton(button: UIImageView(image: UIImage.undoButton))
    private let timerPicture: UIImageView = UIImageView(image: UIImage.timer)
    private let timerLabel: UILabel = CustomText(text: "", fontSize: Constants.timerTextSize, textColor: Colors.white)
    private let timerView = UIView()
    private var levelPicture:  UIImageView = UIImageView()
    private let hintButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.hintButton))
    private let pauseButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.pauseButton))
    private let cleanerButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.cleanerButton))
    private let learningButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.gameLearningButton))
    private let gameLogo: UILabel = CustomText(text: Constants.logoText, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let gamePlayCat: UIImageView = UIImageView(image: UIImage.startPlayCat)
    private var selectedCellIndex: Int? = 0
    private var playground: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.playgroundSpacing
        layout.minimumLineSpacing = Constants.playgroundSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(CrownsPlaygroundCell.self, forCellWithReuseIdentifier: CrownsPlaygroundCell.identifier)
        return collection
    }()
    private var pauseOverlayView: UIView?
    private var cellSize: CGFloat = 0
    private let size: Int = Constants.size
    
    // MARK: - Lifecycle
    init(interactor: CrownsPlayBusinessLogic) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        
        let rBarButtonItem = UIBarButtonItem(customView: timerView)
        navigationItem.rightBarButtonItem = rBarButtonItem
        interactor.startTimer(CrownsPlayModel.StartTimer.Request())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        let isFinished = interactor.isPlayFinished(CrownsPlayModel.CheckGameOver.Request())
        let timeIsUp = interactor.timeIsUp()
        let isChallenge = interactor.isPlayChallenge(CrownsPlayModel.CheckChallenge.Request())
        
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.crownsChallengeGoes)
        
        if !isFinished && !timeIsUp && !isChallenge {
            interactor.leaveGame(CrownsPlayModel.LeaveGame.Request())
        }
    }
    
    // MARK: - Funcs
    func setTimerLabel(_ viewModel: CrownsPlayModel.SetTime.ViewModel) {
        DispatchQueue.main.async {
            self.timerLabel.text = viewModel.timerLabel
        }
    }
    
    func updateCrownsPlayground(_ viewModel: CrownsPlayModel.UpdateCrownsPlayground.ViewModel) {
        if let cell = playground.cellForItem(at: viewModel.indexPath) as? CrownsPlaygroundCell {
            cell.configure(color: viewModel.color, value: viewModel.value, mode: viewModel.mode)
        }
        if interactor.isPlayFinished(CrownsPlayModel.CheckGameOver.Request()) {
            interactor.gameIsWon(CrownsPlayModel.GameIsWon.Request())
        }
    }
    
    func setLevelPicture(_ viewModel: CrownsPlayModel.GetLevel.ViewModel) {
        levelPicture = UIImageView(image: viewModel.image)
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        configureBackground()
        configurePlayground()
        configurePlaygroundButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let lBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = lBarButtonItem
        navigationItem.titleView = gameLogo
        configureTimer()
        
        view.addSubview(gamePlayCat)
        gamePlayCat.pinCenterX(to: view)
        gamePlayCat.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureTimer() {
        timerView.setWidth(timerPicture.frame.width)
        timerView.addSubview(timerPicture)
        view.addSubview(timerLabel)
        timerPicture.pinCenter(to: timerView)
        timerLabel.pinRight(to: view.trailingAnchor, Constants.timerLabelRight)
        timerLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.timerLabelTop)
    }
    
    private func configurePlayground() {
        let availableWidth = view.frame.width - Constants.playgroundPadding
        let padding: CGFloat = 2.0 * (CGFloat(size) - 1.0)
        cellSize = (availableWidth - padding) / CGFloat(size)
        
        playground.delegate = self
        playground.dataSource = self
        
        view.addSubview(playground)
        
        playground.setWidth(availableWidth)
        playground.setHeight(availableWidth)
        playground.pinCenterX(to: view)
        playground.pinCenterY(to: view)
    }
    
    private func configurePlaygroundButtons() {
        interactor.getLevelPictute(CrownsPlayModel.GetLevel.Request())
        
        for subview in [levelPicture, pauseButton, hintButton] {
            view.addSubview(subview)
            subview.pinBottom(to: playground.topAnchor, Constants.buttonsPadding)
        }
        
        for subview in [undoButton, learningButton] {
            view.addSubview(subview)
            subview.pinTop(to: playground.bottomAnchor, Constants.buttonsPadding)
        }
        
        levelPicture.pinLeft(to: playground.leadingAnchor, Constants.buttonsPadding)
        pauseButton.pinCenterX(to: playground)
        hintButton.pinRight(to: playground.trailingAnchor, Constants.buttonsPadding)
        undoButton.pinLeft(to: playground.leadingAnchor, Constants.buttonsPadding)
        learningButton.pinRight(to: playground.trailingAnchor, Constants.buttonsPadding)

        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        learningButton.addTarget(self, action: #selector(learningButtonTapped), for: .touchUpInside)
    }
    
    private func showPauseOverlay() {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = Colors.darkGray.withAlphaComponent(Constants.pauseOverlayAlpha)

        let continueButton: UIButton = CustomButton(button: UIImageView(image: UIImage.button))
        let continueButtonText = CustomText(text: Constants.continueButtonText, fontSize: Constants.continueButtonTextSize, textColor: Colors.white)
        
        continueButton.addSubview(continueButtonText)
        overlay.addSubview(continueButton)
        view.addSubview(overlay)
        
        continueButtonText.pinCenterX(to: continueButton)
        continueButtonText.pinCenterY(to: continueButton, Constants.continueButtonY)
        continueButton.pinCenterX(to: overlay)
        continueButton.pinCenterY(to: overlay)
        
        pauseOverlayView = overlay
        continueButton.addTarget(self, action: #selector(hidePauseOverlay), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func pauseButtonTapped() {
        interactor.pauseButtonTapped(CrownsPlayModel.PauseGame.Request())
        showPauseOverlay()
    }
    
    @objc private func hidePauseOverlay() {
        pauseOverlayView?.removeFromSuperview()
        pauseOverlayView = nil
        interactor.pauseButtonTapped(CrownsPlayModel.PauseGame.Request())
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(CrownsPlayModel.RouteBack.Request())
    }
    
    @objc private func hintButtonTapped() {
        interactor.hintButtonTapped(CrownsPlayModel.GetHint.Request())
    }
    
    @objc private func undoButtonTapped() {
        interactor.undoButtonTapped(CrownsPlayModel.UndoMove.Request())
    }
    
    @objc private func learningButtonTapped() {
        let vc = CrownsLearningBuilder.build()
        present(vc, animated: true)
        for _ in 0...Constants.tapNumbers {
            vc.systemTouchNextButton()
        }
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
        static let logoText: String = "Crowns"
        static let continueButtonText: String = "Continue the game"
        
        static let logoTextSize: CGFloat = 34
        static let timerTextSize: CGFloat = 12
        static let continueButtonTextSize: CGFloat = 20
        
        static var playgroundSpacing: CGFloat = 2
        static var timerLabelRight: CGFloat { 22 * Layout.scaleW }
        static var timerLabelTop: CGFloat { 7 * Layout.scaleH }
        static var playgroundTop: CGFloat { 75 * Layout.scaleH }
        static var buttonsPadding: CGFloat { 10 * Layout.scaleH }
        static var playgroundPadding: CGFloat = 7
        static var continueButtonY: CGFloat { -4 * Layout.scaleH }
        
        static let size = 9
        static let pauseOverlayAlpha = 0.9
        static let tapNumbers = 2
        
    }
}

// MARK: - Extension
extension CrownsPlayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size * size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CrownsPlaygroundCell.identifier, for: indexPath) as! CrownsPlaygroundCell
        let puzzle = interactor.getTable(CrownsPlayModel.GetTable.Request())
        let placements = interactor.getPlacements(CrownsPlayModel.GetPlacements.Request())
        let row = indexPath.item / size
        let col = indexPath.item % size
        let puzzleValue = puzzle[row][col].hasCrown ? CrownsCellContent.crown : CrownsCellContent.empty

        cell.configure(color: puzzle[row][col].color.uiColor, value: puzzleValue, mode: CrownsCellMode.inition)
        if !puzzle[row][col].hasCrown {
            cell.configure(color: puzzle[row][col].color.uiColor, value: placements[row][col], mode: CrownsCellMode.reload)
        }
        
        interactor.placeCrown(CrownsPlayModel.PlaceCrown.Request(row: indexPath.item / size,
                                                                  col: indexPath.item % size,
                                                                  isPlaced: cell.isCrownPlaced()))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CrownsPlaygroundCell {
            interactor.saveMove(CrownsPlayModel.SaveMove.Request(move: CrownsPlayModel.CrownsMove(indexPath: indexPath, value: cell.isCrownPlaced())))
            cell.select()
            interactor.placeCrown(CrownsPlayModel.PlaceCrown.Request(row: indexPath.item / size,
                                                                      col: indexPath.item % size,
                                                                      isPlaced: cell.isCrownPlaced()))
            if interactor.isPlayFinished(CrownsPlayModel.CheckGameOver.Request()) {
                interactor.gameIsWon(CrownsPlayModel.GameIsWon.Request())
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}

