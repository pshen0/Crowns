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
    private let levelPicture:  UIImageView = UIImageView(image: Images.levelPicture)
    private let hintButton:  UIButton = CustomButton(button: UIImageView(image: Images.hintButton))
    private let pauseButton:  UIButton = CustomButton(button: UIImageView(image: Images.pauseButton))
    private let cleanerButton:  UIButton = CustomButton(button: UIImageView(image: Images.cleanerButton))
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
        print(sudokuBoard.table)
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
        let leftBarButtonItem = UIBarButtonItem(customView: timerPicture)
        navigationItem.rightBarButtonItem = leftBarButtonItem
        
        
        for subview in [gameLogo, gamePlayCat] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gamePlayLogoTop)
        gamePlayCat.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
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
        
        let overlayView = CageOverlayView(sudokuBoard.cages, (cellSize - 4.0) / 3.0)
        overlayView.isUserInteractionEnabled = false
        overlayView.frame = playground.bounds
        playground.addSubview(overlayView)
    }
    
    private func configurePlaygroundButtons() {
        for subview in [levelPicture, pauseButton, hintButton] {
            view.addSubview(subview)
            subview.pinBottom(to: playground.topAnchor, 10)
        }
        
        for subview in [undoButton, cleanerButton] {
            view.addSubview(subview)
            subview.pinTop(to: playground.bottomAnchor, 10)
        }
        
        levelPicture.pinLeft(to: playground.leadingAnchor, 10)
        pauseButton.pinCenterX(to: playground)
        undoButton.pinLeft(to: playground.leadingAnchor, 10)
        hintButton.pinRight(to: playground.trailingAnchor, 10)
        cleanerButton.pinRight(to: playground.trailingAnchor, 10)
        
        cleanerButton.addTarget(self, action: #selector(cleanerButtonTapped), for: .touchUpInside)
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
    
    private func isChangeCorrect(row: Int, col: Int, number: Int) -> String {
        if number == 0 {
            return "correct"
        }
        for i in 0..<9 {
            if i != col &&  i != row {
                if sudokuBoard.puzzle[row][i] == number ||  sudokuBoard.puzzle[i][col] == number {
                    return "incorrect"
                }
            }
        }
        
        for i in (row / 3 * 3)...(row / 3 * 3 + 2) {
            for j in (col / 3 * 3)...(col / 3 * 3 + 2) {
                if i != col &&  i != row {
                    if sudokuBoard.puzzle[i][j] == number {
                        return "incorrect"
                    }
                }
            }
        }
        
        if let targetCage = sudokuBoard.cages.first(where: { cage in
            cage.cells.contains { $0.row == row && $0.col == col }
        }) {
            var sum = 0
            var filledCells = 0
            for cell in targetCage.cells {
                if sudokuBoard.puzzle[cell.row][cell.col] != 0 {
                    sum += sudokuBoard.puzzle[cell.row][cell.col]
                    filledCells += 1
                }
                if sum > targetCage.sum {
                    return "incorrect"
                }
                if filledCells == targetCage.cells.count && sum != targetCage.sum {
                    return "incorrect"
                }
            }
        }
        return "correct"
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let index = selectedCellIndex else { return }
        let indexes = interactor.cellChanged(SudokuPlayModel.ChangeCell.Request(index: index))
        
        if sudokuBoard.unsolvedPuzzle[indexes.arrayRow][indexes.arrayCol] == 0 {
            sudokuBoard.puzzle[indexes.arrayRow][indexes.arrayCol] = sender.tag
            for i in 0...8 {
                for j in 0...8 {
                    let blockIndex = (i / 3) * 3 + (j / 3)
                    let cellIndex = (i % 3) * 3 + (j % 3)
                    if sudokuBoard.unsolvedPuzzle[i][j] == 0 {
                        let mode: String = isChangeCorrect(row: i, col: j, number: sudokuBoard.puzzle[i][j])
                        let blockIndexPath = IndexPath(item: blockIndex, section: 0)
                        if let block = playground.cellForItem(at: blockIndexPath) as? KillerSudokuBlock {
                            let cellIndexPath = IndexPath(item: cellIndex, section: 0)
                            if let cell = block.collection.cellForItem(at: cellIndexPath) as? KillerSudokuCell {
                                cell.configure(number: sudokuBoard.puzzle[i][j], mode: mode)
                            }
                        }
                    }
                }
            }
        }
        
        if sudokuBoard.table == sudokuBoard.puzzle {
            interactor.playFinished(SudokuPlayModel.RouteGameOver.Request(isWin: true))
        }
    }
    
    @objc private func cleanerButtonTapped() {
        guard let index = selectedCellIndex else { return }
        let indexes = interactor.cellChanged(SudokuPlayModel.ChangeCell.Request(index: index))
        
        if sudokuBoard.unsolvedPuzzle[indexes.arrayRow][indexes.arrayCol] == 0 {
            sudokuBoard.puzzle[indexes.arrayRow][indexes.arrayCol] = 0
            let blockIndexPath = IndexPath(item: indexes.blockIndex, section: 0)
            if let block = playground.cellForItem(at: blockIndexPath) as? KillerSudokuBlock {
                let cellIndexPath = IndexPath(item: indexes.cellIndex, section: 0)
                if let cell = block.collection.cellForItem(at: cellIndexPath) as? KillerSudokuCell {
                    cell.configure(number: 0, mode: "correct")
                }
            }
            for i in 0...8 {
                for j in 0...8 {
                    let blockIndex = (i / 3) * 3 + (j / 3)
                    let cellIndex = (i % 3) * 3 + (j % 3)
                    if sudokuBoard.unsolvedPuzzle[i][j] == 0 {
                        let mode: String = isChangeCorrect(row: i, col: j, number: sudokuBoard.puzzle[i][j])
                        let blockIndexPath = IndexPath(item: blockIndex, section: 0)
                        if let block = playground.cellForItem(at: blockIndexPath) as? KillerSudokuBlock {
                            let cellIndexPath = IndexPath(item: cellIndex, section: 0)
                            if let cell = block.collection.cellForItem(at: cellIndexPath) as? KillerSudokuCell {
                                cell.configure(number: sudokuBoard.puzzle[i][j], mode: mode)
                            }
                        }
                    }
                }
            }
        }
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
        
        let blockRow = indexPath.item / gridSize
        let blockCol = indexPath.item % gridSize
        var blockData = [Int]()
        var cellsWithSum = [(cellPath: IndexPath, sum: Int)]()
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                let row = blockRow * 3 + i
                let col = blockCol * 3 + j
                blockData.append(sudokuBoard.puzzle[row][col])
            }
        }
        
        for cage in sudokuBoard.cages {
            if let minCageCell = cage.cells.min(by: {
                $0.row < $1.row || ($0.row == $1.row && $0.col < $1.col)
            }) {
                let blockIndex = (minCageCell.row / 3) * 3 + (minCageCell.col / 3)
                let cellIndex = (minCageCell.row % 3) * 3 + (minCageCell.col) % 3
                
                if blockIndex == indexPath.item {
                    let cellIndexPath = IndexPath(item: cellIndex, section: 0)
                    cellsWithSum.append((cellPath: cellIndexPath, sum: cage.sum))
                }
            }
        }
        cell.configure(with: blockData, cellsWithSum)
        
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
