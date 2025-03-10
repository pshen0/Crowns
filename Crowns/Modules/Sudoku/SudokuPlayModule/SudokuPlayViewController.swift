//
//  SudokuPlayViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

final class SudokuPlayViewController: UIViewController {
    
    private let interactor: SudokuPlayBusinessLogic
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    private let gameLogo: UILabel = CustomText(text: Text.sudokuGame, fontSize: Constraints.gameLogoSize, textColor: Colors.white)
    private let gridSize = 3
    private var sudokuBoard = SudokuGrid()
    private var selectedCellIndex: Int? = 0
    private var playground: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
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
        configureNumberButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
        
        view.addSubview(gameLogo)
        for subview in [gameLogo] {
            subview.pinCenterX(to: view)
        }
        
        gameLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.gamePlayLogoTop)
        
        configurePlayground()
        let overlayView = CageOverlayView(sudokuBoard.cages, cellSize / 3)
        overlayView.isUserInteractionEnabled = false
        overlayView.frame = playground.bounds
        playground.addSubview(overlayView)
    }
    
    private func configurePlayground() {
        playground.delegate = self
        playground.dataSource = self
        
        view.addSubview(playground)
        
        playground.pinCenterX(to: view)
        playground.pinCenterY(to: view)
        playground.setWidth(view.frame.width - 7.0)
        playground.setHeight(view.frame.width - 7.0)
        
        
        let availableWidth = view.frame.width - 7.0
        let padding: CGFloat = 5 * (CGFloat(gridSize) - 1)
        cellSize = (availableWidth - padding) / CGFloat(gridSize)
        print(cellSize)
        
        sudokuBoard.show()
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
            
            buttonsStackView.addArrangedSubview(button)
            
            button.setHeight((view.frame.width - 50.0) / 9.0)
            button.setWidth((view.frame.width - 50.0) / 9.0)
            
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        }
        
        view.addSubview(buttonsStackView)
        
        buttonsStackView.pinTop(to: playground.bottomAnchor, 25)
        buttonsStackView.pinCenterX(to: view)
    }
    
    @objc private func backButtonTapped() {
        interactor.backButtonTapped(SudokuPlayModel.RouteBack.Request())
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let index = selectedCellIndex else { return }
        let indexes = interactor.numberButtonTapped(SudokuPlayModel.ChangeNumberCell.Request(index: index))
        
        sudokuBoard.table[indexes.arrayRow][indexes.arrayCol] = sender.tag
        if let block = playground.cellForItem(at: indexes.blockIndexPath) as? KillerSudokuBlock {
            let cellIndexPath = IndexPath(item: indexes.cellIndex, section: 0)
            if let cell = block.collection.cellForItem(at: cellIndexPath) as? KillerSudokuCell {
                cell.configure(number: sender.tag)
            }
        }
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
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                let row = blockRow * 3 + i
                let col = blockCol * 3 + j
                blockData.append(sudokuBoard.table[row][col])
            }
        }
    
        cell.configure(with: blockData)
        
        
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
        let availableWidth = collectionView.frame.size.width
        let padding: CGFloat = 5 * (CGFloat(gridSize) - 1)
        let cellWidth = (availableWidth - padding) / CGFloat(gridSize)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
