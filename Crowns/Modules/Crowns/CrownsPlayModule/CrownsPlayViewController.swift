//
//  CrownsPlayViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

final class CrownsPlayViewController: UIViewController{
    
    private let interactor: CrownsPlayBusinessLogic
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                      tapped: UIImageView(image: Images.backButtonTap))
    private let undoButton: UIButton = CustomButton(button: UIImageView(image: Images.undoButton))
    private let timerPicture: UIImageView = UIImageView(image: Images.timerPicture)
    private let timerLabel: UILabel = CustomText(text: "", fontSize: Constraints.gameplayLogoSize, textColor: Colors.white)
    private let timerView = UIView()
    private let levelPicture:  UIImageView = UIImageView(image: Images.levelPicture)
    private let hintButton:  UIButton = CustomButton(button: UIImageView(image: Images.hintButton))
    private let pauseButton:  UIButton = CustomButton(button: UIImageView(image: Images.pauseButton))
    private let cleanerButton:  UIButton = CustomButton(button: UIImageView(image: Images.cleanerButton))
    private let learningButton:  UIButton = CustomButton(button: UIImageView(image: Images.gameLearningButton))
    private let gameLogo: UILabel = CustomText(text: Text.crownsGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    private let gamePlayCat: UIImageView = UIImageView(image: Images.gamePlayCat)
    private var selectedCellIndex: Int? = 0
    private var playground: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constraints.crownsPlaygroundSpacing
        layout.minimumLineSpacing = Constraints.crownsPlaygroundSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(CrownsPlaygroundCell.self, forCellWithReuseIdentifier: CrownsPlaygroundCell.identifier)
        return collection
    }()
    private var cellSize: CGFloat = 0
    private let gridSize: Int = 9
    
    init(interactor: CrownsPlayBusinessLogic) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        interactor.startTimer(CrownsPlayModel.StartTimer.Request())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        if !interactor.isPlayFinished(CrownsPlayModel.CheckGameOver.Request()) && !interactor.timeIsUp() {
            interactor.leaveGame(CrownsPlayModel.LeaveGame.Request())
        }
    }
    
    private func configureUI() {
        configureBackground()
        configurePlayground()
        configurePlaygroundButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = rightBarButtonItem
        configureTimer()
        let leftBarButtonItem = UIBarButtonItem(customView: timerView)
        navigationItem.rightBarButtonItem = leftBarButtonItem
        
        for subview in [gameLogo, gamePlayCat] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gamePlayLogoTop)
        gamePlayCat.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureTimer() {
        timerView.setWidth(timerPicture.frame.width)
        timerView.addSubview(timerPicture)
        timerView.addSubview(timerLabel)
        timerPicture.pinCenter(to: timerView)
        timerLabel.pinCenterX(to: timerPicture)
        timerLabel.pinTop(to: timerPicture.bottomAnchor, 5)
    }
    
    private func configurePlayground() {
        let availableWidth = view.frame.width - 7.0
        let padding: CGFloat = 2.0 * (CGFloat(gridSize) - 1.0)
        cellSize = (availableWidth - padding) / CGFloat(gridSize)
        playground.delegate = self
        playground.dataSource = self
        
        view.addSubview(playground)
        
        playground.pinCenterX(to: view)
        playground.pinTop(to: gameLogo.bottomAnchor, 75)
        playground.setWidth(availableWidth)
        playground.setHeight(availableWidth)
    }
    
    private func configurePlaygroundButtons() {
        for subview in [levelPicture, pauseButton, hintButton] {
            view.addSubview(subview)
            subview.pinBottom(to: playground.topAnchor, 10)
        }
        
        for subview in [undoButton, learningButton] {
            view.addSubview(subview)
            subview.pinTop(to: playground.bottomAnchor, 10)
        }
        
        levelPicture.pinLeft(to: playground.leadingAnchor, 10)
        pauseButton.pinCenterX(to: playground)
        hintButton.pinRight(to: playground.trailingAnchor, 10)
        undoButton.pinLeft(to: playground.leadingAnchor, 10)
        learningButton.pinRight(to: playground.trailingAnchor, 10)

        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
    }
    
    func setTimerLabel(_ viewModel: CrownsPlayModel.SetTime.ViewModel) {
        timerLabel.text = viewModel.timerLabel
    }
    
    func updateCrownsPlayground(_ viewModel: CrownsPlayModel.UpdateCrownsPlayground.ViewModel) {
        if let cell = playground.cellForItem(at: viewModel.indexPath) as? CrownsPlaygroundCell {
            cell.configure(color: viewModel.color, value: viewModel.value, mode: viewModel.mode)
        }
        if interactor.isPlayFinished(CrownsPlayModel.CheckGameOver.Request()) {
            interactor.gameIsWon(CrownsPlayModel.GameIsWon.Request())
        }
    }
    
    @objc private func pauseButtonTapped() {
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
}

extension CrownsPlayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CrownsPlaygroundCell.identifier, for: indexPath) as! CrownsPlaygroundCell
        let puzzle = interactor.getTable(CrownsPlayModel.GetTable.Request())
        let placements = interactor.getPlacements(CrownsPlayModel.GetPlacements.Request())
        let row = indexPath.item / 9
        let col = indexPath.item % 9
        let puzzleValue = puzzle[row][col].hasCrown ? 2 : 0

        cell.configure(color: puzzle[row][col].color.uiColor, value: puzzleValue, mode: "inition")
        if !puzzle[row][col].hasCrown {
            cell.configure(color: puzzle[row][col].color.uiColor, value: placements[row][col], mode: "reload")
        }
        
        interactor.placeCrown(CrownsPlayModel.PlaceCrown.Request(row: indexPath.item / 9,
                                                                  col: indexPath.item % 9,
                                                                  isPlaced: cell.isCrownPlaced()))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CrownsPlaygroundCell {
            interactor.saveMove(CrownsPlayModel.SaveMove.Request(move: CrownsMove(indexPath: indexPath, value: cell.isCrownPlaced())))
            cell.select()
            interactor.placeCrown(CrownsPlayModel.PlaceCrown.Request(row: indexPath.item / 9,
                                                                      col: indexPath.item % 9,
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

