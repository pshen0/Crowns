//
//  SudokuLearningViewController.swift
//  Crowns
//
//  Created by Анна Сазонова on 02.02.2025.
//

import UIKit

final class SudokuLearningViewController: UIViewController {
    
    private let interactor: SudokuLearningBusinessLogic
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    private let backButton: UIButton = CustomButton(button: UIImageView(image: Images.backButton),
                                                    tapped: UIImageView(image: Images.backButtonTap))
    private let gridSize = 3
    
    private var selectedCellIndex: Int? = 0
    private var board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    private var playground: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(KillerSudokuBlock.self, forCellWithReuseIdentifier: KillerSudokuBlock.identifier)
        return collection
    }()
    
    init(interactor: SudokuLearningBusinessLogic) {
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
        configureNumberButtons()
    }
    
    private func configureBackground() {
        view.backgroundColor = Colors.darkGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func configurePlayground() {
        playground.delegate = self
        playground.dataSource = self
        
        view.addSubview(playground)
        
        playground.pinCenterX(to: view)
        playground.pinCenterY(to: view)
        playground.setWidth(view.frame.width - 7.0)
        playground.setHeight(view.frame.width - 7.0)
        
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
        interactor.backButtonTapped(SudokuLearningModel.RouteBack.Request())
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let index = selectedCellIndex else { return }
        board[index / 9][index % 9] = sender.tag
        print(index)
        print (board)
    }
}

extension SudokuLearningViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KillerSudokuBlock.identifier, for: indexPath) as! KillerSudokuBlock
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
        let padding: CGFloat = 3 * (CGFloat(gridSize) - 1)
        let cellWidth = (availableWidth - padding) / CGFloat(gridSize)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
