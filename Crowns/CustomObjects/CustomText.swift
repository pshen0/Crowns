//
//  CustomText.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

final class CustomText: UILabel {
    
    init(text: String, fontSize: CGFloat, textColor: UIColor = .black) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        setupFont(with: fontSize)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFont(with: Constants.textSize)
        setupUI()
    }
    
    private func setupFont(with size: CGFloat) {
        if let customFont = UIFont(name: Fonts.IrishGrover, size: size) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: size)
        }
    }
    
    private func setupUI() {
        self.numberOfLines = 0
        self.textAlignment = .center
    }
    
    private enum Constants {
        static let textSize: CGFloat = 17
    }
}
