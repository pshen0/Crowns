//
//  CrownsPlaygroundCell.swift
//  Crowns
//
//  Created by Анна Сазонова on 14.03.2025.
//

import UIKit

// MARK: - CrownsPlaygroundCell class
final class CrownsPlaygroundCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = CellsID.crownsCellId
    private let crownImage: UIImageView = UIImageView(image: UIImage.crown)
    private let pointImage: UIImageView = UIImageView(image: UIImage.point)
    private var mode = ""
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Errors.initErrorCoder)
    }
    
    // MARK: - Funcs
    func configure(color: UIColor, value: Int, mode: String) {
        if mode == CrownsCellMode.inition && value == CrownsCellContent.crown {
            self.mode = mode
        }
        contentView.backgroundColor = color
        if value == CrownsCellContent.crown {
            crownImage.isHidden = false
            pointImage.isHidden = true
        } else if value == CrownsCellContent.cross {
            crownImage.isHidden = true
            pointImage.isHidden = false
        } else {
            crownImage.isHidden = true
            pointImage.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        contentView.setWidth(self.frame.width)
        contentView.setHeight(self.frame.width)
    }
    
    func select() {
        if mode == CrownsCellMode.inition {
            return
        } else {
            if crownImage.isHidden && pointImage.isHidden {
                pointImage.isHidden = false
            } else if pointImage.isHidden == false {
                pointImage.isHidden = true
                crownImage.isHidden = false
            } else {
                crownImage.isHidden = true
            }
        }
    }
    
    func isCrownPlaced() -> Int {
        if crownImage.isHidden == false {
            return CrownsCellContent.crown
        } else if pointImage.isHidden == false {
            return CrownsCellContent.cross
        } else {
            return CrownsCellContent.empty
        }
    }
    
    // MARK: - Private funcs
    private func configureCell() {
        contentView.addSubview(crownImage)
        contentView.addSubview(pointImage)
        
        contentView.setWidth(self.frame.width)
        contentView.setHeight(self.frame.width)
        crownImage.pinCenter(to: contentView)
        pointImage.pinCenter(to: contentView)
        crownImage.isHidden = true
        pointImage.isHidden = true
    }
}
