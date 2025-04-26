//
//  PlaygroundCell.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import UIKit

final class KillerSudokuBlock: UICollectionViewCell {
    static let identifier = "KillerSudokuCell"
    
    var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    var onCellSelected: ((Int) -> Void)?
    var data: [Int] = Array(repeating: 0, count: 9)
    var cellsWithSum: [(cellPath: IndexPath, sum: Int)] = []
    private var initiallyFilledCells: Set<Int> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collection.register(KillerSudokuCell.self, forCellWithReuseIdentifier: KillerSudokuCell.identifier)
        configureBlock()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    private func configureBlock() {
        collection.dataSource = self
        collection.delegate = self
        addSubview(collection)
        
        collection.pinCenterX(to: self)
        collection.pinCenterY(to: self)
        collection.setWidth(self.frame.width)
        collection.setHeight(self.frame.width)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collection.frame = bounds
        collection.setWidth(self.frame.width)
        collection.setHeight(self.frame.width)

        collection.collectionViewLayout.invalidateLayout()
    }
    
    func configure(data: [Int], initData: [Int], _ cellsWithSum: [(cellPath: IndexPath, sum: Int)]) {
        self.data = data
        self.cellsWithSum = cellsWithSum
        initiallyFilledCells = Set(initData.enumerated().compactMap { $0.element != 0 ? $0.offset : nil })
        collection.reloadData()
    }
    
    func deselect() {
        for section in 0..<collection.numberOfSections {
            for item in 0..<collection.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let cell = collection.cellForItem(at: indexPath) as? KillerSudokuCell {
                    cell.deselect()
                }
            }
        }
    }
}

extension KillerSudokuBlock: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KillerSudokuCell.identifier, for: indexPath) as! KillerSudokuCell
        let mode = initiallyFilledCells.contains(indexPath.item) ? "inition" : "correct"
        cell.configure(number: data[indexPath.item], mode: mode)
        if let foundCell = cellsWithSum.first(where: { $0.cellPath.item == indexPath.item }) {
            cell.addSumLabel(sum: foundCell.sum)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? KillerSudokuCell {
            cell.select()
        }
        
        let innerIndex = indexPath.item
        onCellSelected?(innerIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? KillerSudokuCell {
            cell.deselect()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - 4.0
        let cellWidth = availableWidth / 3.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

final class KillerSudokuCell: UICollectionViewCell {
    static let identifier = "KillerSudokuCell"
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        label.textAlignment = .center
        label.textColor = Colors.white
        return label
    }()
    private var mode = ""
    private var selectedMode: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    private func configureCell() {
        contentView.addSubview(valueLabel)
        contentView.addSubview(sumLabel)
        
        contentView.setWidth(self.frame.width)
        contentView.setHeight(self.frame.width)
        valueLabel.pinCenterX(to: contentView.centerXAnchor)
        valueLabel.pinCenterY(to: contentView.centerYAnchor)
        sumLabel.pinLeft(to: contentView.leadingAnchor, 2)
        sumLabel.pinTop(to: contentView.topAnchor, 2)
        
        contentView.backgroundColor = Colors.lightGray
    }
    
    func configure(number: Int, mode: String) {
        valueLabel.text = number == 0 ? "" : "\(number)"
        self.mode = mode
        switch self.mode {
        case "inition":
            sumLabel.textColor = Colors.white
            valueLabel.textColor = Colors.yellow
            contentView.backgroundColor = Colors.lightGray
        case "incorrect":
            valueLabel.textColor = .red
        default:
            if self.selectedMode {
                contentView.backgroundColor = Colors.yellow
                valueLabel.textColor = Colors.darkGray
                sumLabel.textColor = Colors.darkGray
            } else {
                contentView.backgroundColor = Colors.lightGray
                valueLabel.textColor = Colors.white
                sumLabel.textColor = Colors.white
            }
            
        }
    }
    
    func addSumLabel(sum: Int) {
        sumLabel.text = sum == 0 ? "" : "\(sum)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        contentView.setWidth(self.frame.width)
        contentView.setHeight(self.frame.width)
    }
    
    func select() {
        selectedMode = true
        switch mode {
        case "inition":
            return
        case "incorrect":
            contentView.backgroundColor = Colors.yellow
            sumLabel.textColor = Colors.darkGray
        default:
            contentView.backgroundColor = Colors.yellow
            valueLabel.textColor = Colors.darkGray
            sumLabel.textColor = Colors.darkGray
        }
    }
    
    func deselect() {
        selectedMode = false
        switch mode {
        case "inition":
            return
        case "incorrect":
            contentView.backgroundColor = Colors.lightGray
            sumLabel.textColor = Colors.white
        default:
            contentView.backgroundColor = Colors.lightGray
            valueLabel.textColor = Colors.white
            sumLabel.textColor = Colors.white
        }
    }
}
