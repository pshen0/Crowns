//
//  SudokuPlayViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

// MARK: - SudokuPlayViewController class
final class SudokuPlayViewController: UIViewController {
    
    // MARK: - Properties
    private let interactor: SudokuPlayBusinessLogic
    private let numberButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Constants.numberButtonStackSpacing
        return stack
    }()
    
    private let backButton: UIButton = CustomButton(button: UIImageView(image: UIImage.backButton),
                                                    tapped: UIImageView(image: UIImage.backButtonTap))
    private let undoButton: UIButton = CustomButton(button: UIImageView(image: UIImage.undoButton))
    private let timerPicture: UIImageView = UIImageView(image: UIImage.timer)
    private let timerLabel: UILabel = CustomText(text: "", fontSize: Constants.timerTextSize, textColor: Colors.white)
    private let timerView = UIView()
    private var levelPicture:  UIImageView = UIImageView(image: UIImage.easy)
    private let hintButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.hintButton))
    private let pauseButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.pauseButton))
    private let cleanerButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.cleanerButton))
    private let learningButton:  UIButton = CustomButton(button: UIImageView(image: UIImage.gameLearningButton))
    private let gameLogo: UILabel = CustomText(text: Constants.logoText, fontSize: Constants.logoTextSize, textColor: Colors.white)
    private let gamePlayCat: UIImageView = UIImageView(image: UIImage.startPlayCat)
    private let size = Constants.size
    private var selectedCellIndex: Int? = 0
    private var playground: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.playgroundSpacing
        layout.minimumLineSpacing = Constants.playgroundSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(KillerSudokuBlock.self, forCellWithReuseIdentifier: KillerSudokuBlock.identifier)
        return collection
    }()
    private var cellSize: CGFloat = 0
    private var pauseOverlayView: UIView?
    
    // MARK: - Lifecycle
    init(interactor: SudokuPlayBusinessLogic) {
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
        interactor.startTimer(SudokuPlayModel.StartTimer.Request())
        
        playground.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        let isFinished = interactor.isPlayFinished(SudokuPlayModel.CheckGameOver.Request())
        let timeIsUp = interactor.timeIsUp()
        let isChallenge = interactor.isPlayChallenge(SudokuPlayModel.CheckChallenge.Request())
        
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.sudokuChallengeGoes)
        
        if !isFinished && !timeIsUp && !isChallenge {
            interactor.leaveGame(SudokuPlayModel.LeaveGame.Request())
        }
    }
    
    // MARK: - Funcs
    func setTimerLabel(_ viewModel: SudokuPlayModel.SetTime.ViewModel) {
        DispatchQueue.main.async {
            self.timerLabel.text = viewModel.timerLabel
        }
    }
    
    func presentChanges(_ viewModel: SudokuPlayModel.ChangeCell.ViewModel) {
        for changedCell in viewModel.changes {
            if let block = playground.cellForItem(at: changedCell.blockIndex) as? KillerSudokuBlock {
                if let cell = block.collection.cellForItem(at: changedCell.cellIndex) as? KillerSudokuCell {
                    cell.configure(number: changedCell.number, mode: changedCell.mode)
                }
            }
        }
    }
    
    func setLevelPicture(_ viewModel: SudokuPlayModel.GetLevel.ViewModel) {
        levelPicture = UIImageView(image: viewModel.image)
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        configureBackground()
        configurePlayground()
        configurePlaygroundButtons()
        configureNumberButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = rightBarButtonItem
        configureTimer()
        let leftBarButtonItem = UIBarButtonItem(customView: timerView)
        navigationItem.rightBarButtonItem = leftBarButtonItem
        navigationItem.titleView = gameLogo
        
        view.addSubview(gamePlayCat)
        gamePlayCat.contentMode = .scaleAspectFit
        gamePlayCat.setHeight(gamePlayCat.bounds.height *  Layout.scaleH)
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
        let padding: CGFloat = Constants.playgroundSpacing * (CGFloat(size) - 1.0)
        cellSize = (availableWidth - padding) / CGFloat(size)
        playground.delegate = self
        playground.dataSource = self
        
        view.addSubview(playground)
        
        playground.pinCenterX(to: view)
        playground.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.playgroundTop)
        playground.setWidth(availableWidth)
        playground.setHeight(availableWidth)
        
        let cages = interactor.getCages(SudokuPlayModel.GetCages.Request())
        let overlayView = CageOverlayView(cages, (cellSize - Constants.cellPadding) / CGFloat(size))
        overlayView.isUserInteractionEnabled = false
        overlayView.frame = playground.bounds
        playground.addSubview(overlayView)
    }
    
    private func configurePlaygroundButtons() {
        interactor.getLevelPictute(SudokuPlayModel.GetLevel.Request())
        
        for subview in [levelPicture, pauseButton, hintButton] {
            view.addSubview(subview)
            subview.pinBottom(to: playground.topAnchor, Constants.buttonsPadding)
        }
        
        for subview in [undoButton, cleanerButton, learningButton] {
            view.addSubview(subview)
            subview.pinTop(to: playground.bottomAnchor, Constants.buttonsPadding)
        }
        
        levelPicture.pinLeft(to: playground.leadingAnchor, Constants.buttonsPadding)
        pauseButton.pinCenterX(to: playground)
        undoButton.pinLeft(to: playground.leadingAnchor, Constants.buttonsPadding)
        hintButton.pinRight(to: playground.trailingAnchor, Constants.buttonsPadding)
        cleanerButton.pinCenterX(to: playground)
        learningButton.pinRight(to: playground.trailingAnchor, Constants.buttonsPadding)
        
        
        cleanerButton.addTarget(self, action: #selector(cleanerButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        learningButton.addTarget(self, action: #selector(learningButtonTapped), for: .touchUpInside)
    }
    
    private func configureNumberButtons() {
        for i in Constants.digits {
            let button = UIButton(type: .system)
            button.setTitle("\(i)", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.numberBittonTextSize)
            button.setTitleColor(Colors.white, for: .normal)
            button.backgroundColor = Colors.lightGray
            button.layer.cornerRadius = Constants.numberButtonRadius
            button.tag = i
            
            numberButtonsStackView.addArrangedSubview(button)
            
            button.setHeight((view.frame.width - Constants.numberStackPadding) / CGFloat(Constants.digits.count) * Layout.scaleH)
            button.setWidth((view.frame.width - Constants.numberStackPadding) / CGFloat(Constants.digits.count))
            
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        }
        
        view.addSubview(numberButtonsStackView)
        
        numberButtonsStackView.pinTop(to: undoButton.bottomAnchor, Constants.buttonsPadding)
        numberButtonsStackView.pinCenterX(to: view)
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
    @objc private func hidePauseOverlay() {
        pauseOverlayView?.removeFromSuperview()
        pauseOverlayView = nil
        interactor.pauseButtonTapped(SudokuPlayModel.PauseGame.Request())
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let index = selectedCellIndex else { return }
        
        interactor.saveMove(SudokuPlayModel.SaveMove.Request(index: index))
        interactor.numberButtonTapped(SudokuPlayModel.ChangeCellNumber.Request(index: index, number: sender.tag))
        
        if interactor.isPlayFinished(SudokuPlayModel.CheckGameOver.Request()) {
            interactor.gameIsWon(SudokuPlayModel.GameIsWon.Request())
        }
    }
    
    @objc private func cleanerButtonTapped() {
        guard let index = selectedCellIndex else { return }

        interactor.saveMove(SudokuPlayModel.SaveMove.Request(index: index))
        interactor.cleanButtonTapped(SudokuPlayModel.DeleteCellNumber.Request(index: index))
    }
    
    @objc private func pauseButtonTapped() {
        interactor.pauseButtonTapped(SudokuPlayModel.PauseGame.Request())
        showPauseOverlay()
    }
    
    @objc private func hintButtonTapped() {
        interactor.hintButtonTapped(SudokuPlayModel.GetHint.Request())
        if interactor.isPlayFinished(SudokuPlayModel.CheckGameOver.Request()) {
            interactor.gameIsWon(SudokuPlayModel.GameIsWon.Request())
        }
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(SudokuPlayModel.RouteBack.Request())
    }
    
    @objc private func undoButtonTapped() {
        interactor.undoButtonTapped(SudokuPlayModel.UndoMove.Request())
    }
    
    @objc private func learningButtonTapped() {
        let vc = SudokuLearningBuilder.build()
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
        static let logoText: String = "Sudoku"
        static let continueButtonText: String = "Continue the game"
        
        static let numberButtonStackSpacing = 4.0
        static let playgroundSpacing = 5.0
        static let logoTextSize: CGFloat = 34
        static let timerTextSize: CGFloat = 12
        static let continueButtonTextSize: CGFloat = 20
        static let numberBittonTextSize = 24.0
        static let numberButtonRadius = 8.0
        
        static var timerLabelRight: CGFloat { 22 * Layout.scaleH }
        static var timerLabelTop: CGFloat { 7 * Layout.scaleH }
        static var playgroundTop: CGFloat { 75 * Layout.scaleH }
        static var buttonsPadding: CGFloat { 10 * Layout.scaleH }
        static let playgroundPadding = 7.0
        static var continueButtonY: CGFloat { -4 * Layout.scaleH }
        static var numberStackPadding: CGFloat { 50 * Layout.scaleH }
        
        static let size = 3
        static let pauseOverlayAlpha = 0.9
        static let tapNumbers = 2
        static let digits = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        static let cellPadding = 4.0
    }
}

// MARK: - Extensions
extension SudokuPlayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size * size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KillerSudokuBlock.identifier, for: indexPath) as! KillerSudokuBlock
        
        let data = interactor.determineCellsWithSum(SudokuPlayModel.DetermineCellsWithSum.Request(index: indexPath.item))
        
        cell.configure(data: data.blockData, initData: data.initData, data.cellsWithSum)
        
        cell.onCellSelected = { innerIndex in
            self.selectedCellIndex = indexPath.item * (self.size * self.size) + innerIndex
            for section in 0 ..< self.playground.numberOfSections {
                for item in 0 ..< self.playground.numberOfItems(inSection: section) {
                    let curIndexPath = IndexPath(item: item, section: section)
                    if curIndexPath != indexPath {
                        if let cell = self.playground.cellForItem(at: curIndexPath) as? KillerSudokuBlock {
                            cell.deselect()
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}
