//
//  CrownsPlaygroundCell.swift
//  Crowns
//
//  Created by Анна Сазонова on 14.03.2025.
//

import UIKit

final class CrownsPlaygroundCell: UICollectionViewCell {
    static let identifier = "CrownsCell"
    private let crownImage: UIImageView = UIImageView(image: Images.crown)
    private let pointImage: UIImageView = UIImageView(image: Images.point)
    private var mode = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
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

    func configure(color: UIColor, value: Int, mode: String) {
        if mode == "inition" && value == 2 {
            self.mode = mode
        }
        contentView.backgroundColor = color
        if value ==  2 {
            crownImage.isHidden = false
            pointImage.isHidden = true
        } else if value == 1 {
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
        if mode == "inition" {
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
            return 2
        } else if pointImage.isHidden == false {
            return 1
        } else {
            return 0
        }
    }
}
