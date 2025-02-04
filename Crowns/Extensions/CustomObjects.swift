//
//  CustomObjects.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit


class CustomButton: UIButton {
    init(button: UIImageView) {
        super.init(frame: .zero)
        if let image = button.image {
            setImage(image, for: .normal)
        }
    }
    
    init(button: UIImageView, tapped: UIImageView) {
        super.init(frame: .zero)
        if let image1 = button.image, let image2 = tapped.image {
            setImage(image1, for: .normal)
            setImage(image2, for: .highlighted)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initError)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

class CustomText: UILabel {
    
    init(text: String, fontSize: CGFloat, textColor: UIColor = .black) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        setupFont(with: fontSize)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFont(with: Constraints.textSize)
        setupUI()
    }
    
    private func setupFont(with size: CGFloat) {
        if let customFont = UIFont(name: Text.fontIrishGrover, size: size) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: size)
        }
    }

    private func setupUI() {
        self.numberOfLines = 0
        self.textAlignment = .center
    }
}

class BlinkingCatView: UIImageView {
    
    private let animationFrames: [UIImage?]
    
    init(images: [UIImage?], duration: TimeInterval, repeatCount: Int) {
        self.animationFrames = images + images.reversed()
        super.init(frame: .zero)
        setupAnimation(duration: duration, repeatCount: repeatCount)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initError)
    }
        
    override init(frame: CGRect) {
        fatalError("Use init(images:) instead")
    }
    
    private func setupAnimation(duration: TimeInterval, repeatCount: Int) {
        if let image = animationFrames.first {
            self.image = image
        }
        self.animationImages = animationFrames.compactMap { $0 }
        self.animationDuration = duration
        self.animationRepeatCount = repeatCount
    }
    
    func startBlinking() {
        self.startAnimating()
    }
    
}

