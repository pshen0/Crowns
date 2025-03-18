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
    private var crownsPlacements: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
        
        levelPicture.pinLeft(to: playground.leadingAnchor, 10)
        pauseButton.pinCenterX(to: playground)
        hintButton.pinRight(to: playground.trailingAnchor, 10)

        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    func setTimerLabel(_ viewModel: CrownsPlayModel.SetTime.ViewModel) {
        timerLabel.text = viewModel.timerLabel
    }
    
    @objc private func pauseButtonTapped() {
        interactor.pauseButtonTapped(CrownsPlayModel.PauseGame.Request())
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(CrownsPlayModel.RouteBack.Request())
    }
}

extension CrownsPlayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CrownsPlaygroundCell.identifier, for: indexPath) as! CrownsPlaygroundCell
        let puzzle = interactor.getTable(CrownsPlayModel.GetTable.Request())
        let row = indexPath.item / 9
        let col = indexPath.item % 9

        cell.configure(color: puzzle[row][col].color, hasCrown: puzzle[row][col].hasCrown, mode: "inition")
        crownsPlacements[indexPath.item / 9][indexPath.item % 9] = cell.isCrownPlaced()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CrownsPlaygroundCell {
            cell.select()
            crownsPlacements[indexPath.item / 9][indexPath.item % 9] = cell.isCrownPlaced()
            interactor.isPlayFinished(CrownsPlayModel.CheckGameOver.Request(crownsPlacements: crownsPlacements))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}

