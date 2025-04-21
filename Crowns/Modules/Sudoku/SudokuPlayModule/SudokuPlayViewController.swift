//
//  SudokuPlayViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

final class SudokuPlayViewController: UIViewController {
    
    private let interactor: SudokuPlayBusinessLogic
    private let numberButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    private let undoButton: UIButton = CustomButton(button: UIImageView(image: Images.undoButton))
    private let timerPicture: UIImageView = UIImageView(image: Images.timerPicture)
    private let timerLabel: UILabel = CustomText(text: "", fontSize: 12, textColor: Colors.white)
    private let timerView = UIView()
    private let levelPicture:  UIImageView = UIImageView(image: Images.easyLevel)
    private let hintButton:  UIButton = CustomButton(button: UIImageView(image: Images.hintButton))
    private let pauseButton:  UIButton = CustomButton(button: UIImageView(image: Images.pauseButton))
    private let cleanerButton:  UIButton = CustomButton(button: UIImageView(image: Images.cleanerButton))
    private let learningButton:  UIButton = CustomButton(button: UIImageView(image: Images.gameLearningButton))
    private let gameLogo: UILabel = CustomText(text: Text.sudokuGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    private let gamePlayCat: UIImageView = UIImageView(image: Images.gamePlayCat)
    private let gridSize = 3
    private var selectedCellIndex: Int? = 0
    private var playground: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(KillerSudokuBlock.self, forCellWithReuseIdentifier: KillerSudokuBlock.identifier)
        return collection
    }()
    private var cellSize: CGFloat = 0
    
    init(interactor: SudokuPlayBusinessLogic) {
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
        let padding: CGFloat = 5.0 * (CGFloat(gridSize) - 1.0)
        cellSize = (availableWidth - padding) / CGFloat(gridSize)
        playground.delegate = self
        playground.dataSource = self
        
        view.addSubview(playground)
        
        playground.pinCenterX(to: view)
        playground.pinTop(to: gameLogo.bottomAnchor, 75)
        playground.setWidth(availableWidth)
        playground.setHeight(availableWidth)
        
        let cages = interactor.getCages(SudokuPlayModel.GetCages.Request())
        let overlayView = CageOverlayView(cages, (cellSize - 4.0) / 3.0)
        overlayView.isUserInteractionEnabled = false
        overlayView.frame = playground.bounds
        playground.addSubview(overlayView)
    }
    
    private func configurePlaygroundButtons() {
        for subview in [levelPicture, pauseButton, hintButton] {
            view.addSubview(subview)
            subview.pinBottom(to: playground.topAnchor, 10)
        }
        
        for subview in [undoButton, cleanerButton, learningButton] {
            view.addSubview(subview)
            subview.pinTop(to: playground.bottomAnchor, 10)
        }
        
        levelPicture.pinLeft(to: playground.leadingAnchor, 10)
        pauseButton.pinCenterX(to: playground)
        undoButton.pinLeft(to: playground.leadingAnchor, 10)
        hintButton.pinRight(to: playground.trailingAnchor, 10)
        cleanerButton.pinCenterX(to: playground)
        learningButton.pinRight(to: playground.trailingAnchor, 10)
        
        
        cleanerButton.addTarget(self, action: #selector(cleanerButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    private func configureNumberButtons() {
        for i in 1...9 {
            let button = UIButton(type: .system)
            button.setTitle("\(i)", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            button.setTitleColor(Colors.white, for: .normal)
            button.backgroundColor = Colors.lightGray
            button.layer.cornerRadius = 8
            button.tag = i
            
            numberButtonsStackView.addArrangedSubview(button)
            
            button.setHeight((view.frame.width - 50.0) / 9.0)
            button.setWidth((view.frame.width - 50.0) / 9.0)
            
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        }
        
        view.addSubview(numberButtonsStackView)
        
        numberButtonsStackView.pinTop(to: undoButton.bottomAnchor, 10)
        numberButtonsStackView.pinCenterX(to: view)
    }
    
    func setTimerLabel(_ viewModel: SudokuPlayModel.SetTime.ViewModel) {
        timerLabel.text = viewModel.timerLabel
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let index = selectedCellIndex else { return }
        
        let changedCells = interactor.numberButtonTapped(SudokuPlayModel.ChangeCellNumber.Request(index: index, number: sender.tag))
        
        for changedCell in changedCells {
            if let block = playground.cellForItem(at: changedCell.blockIndex) as? KillerSudokuBlock {
                if let cell = block.collection.cellForItem(at: changedCell.cellIndex) as? KillerSudokuCell {
                    cell.configure(number: changedCell.number, mode: changedCell.mode)
                }
            }
        }
        
        interactor.isPlayFinished(SudokuPlayModel.CheckGameOver.Request())
    }
    
    @objc private func cleanerButtonTapped() {
        guard let index = selectedCellIndex else { return }
        
        let changedCells = interactor.cleanButtonTapped(SudokuPlayModel.DeleteCellNumber.Request(index: index))
        
        for changedCell in changedCells {
            if let block = playground.cellForItem(at: changedCell.blockIndex) as? KillerSudokuBlock {
                if let cell = block.collection.cellForItem(at: changedCell.cellIndex) as? KillerSudokuCell {
                    cell.configure(number: changedCell.number, mode: changedCell.mode)
                }
            }
        }
    }
    
    @objc private func pauseButtonTapped() {
        interactor.pauseButtonTapped(SudokuPlayModel.PauseGame.Request())
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(SudokuPlayModel.RouteBack.Request())
    }
}

extension SudokuPlayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KillerSudokuBlock.identifier, for: indexPath) as! KillerSudokuBlock
        
        let data = interactor.determineCellsWithSum(SudokuPlayModel.DetermineCellsWithSum.Request(index: indexPath.item))
        
        cell.configure(with: data.blockData, data.cellsWithSum)
        
        cell.onCellSelected = { innerIndex in
            self.selectedCellIndex = indexPath.item * 9 + innerIndex
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
