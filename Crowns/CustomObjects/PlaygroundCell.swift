//
//  PlaygroundCell.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import UIKit

final class KillerSudokuBlock: UICollectionViewCell {
    static let identifier = "KillerSudokuCell"
    
    private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    var onCellSelected: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collection.register(KillerSudokuCell.self, forCellWithReuseIdentifier: KillerSudokuCell.identifier)
        configureBlock()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KillerSudokuCell.identifier, for: indexPath)
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
        
        let availableWidth = collectionView.frame.size.width
        let cellWidth = (availableWidth) / CGFloat(3)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

class KillerSudokuCell: UICollectionViewCell {
    static let identifier = "KillerSudokuCell"
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.addSubview(label)
        label.pinCenterX(to: contentView.centerXAnchor)
        label.pinCenterY(to: contentView.centerYAnchor)
        
        contentView.layer.borderColor = Colors.darkGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = Colors.lightGray
    }
    
    func configure(number: Int) {
        label.text = number == 0 ? "" : "\(number)"
    }
    
    func select() {
        contentView.backgroundColor = Colors.yellow
    }
    
    func deselect() {
        contentView.backgroundColor = Colors.lightGray
    }
}
