//
//  CustomObjects.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit


class CustomButton: UIButton {
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
    
    private let catAnimation1: UIImage? = Images.cat1
    private let catAnimation2: UIImage? = Images.cat2
    private let catAnimation3: UIImage? = Images.cat3
    private let catAnimation4: UIImage? = Images.cat4
    private let catAnimation5: UIImage? = Images.cat5
    private let catAnimation6: UIImage? = Images.cat6
    private let catAnimation7: UIImage? = Images.cat7
    
    init() {
        super.init(frame: .zero)
        setupAnimation()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initError)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupAnimation() {
        self.image = catAnimation1
        
        if let image1 = catAnimation1, let image2 = catAnimation2, let image3 = catAnimation3, let image4 = catAnimation4,
           let image5 = catAnimation5, let image6 = catAnimation6, let image7 = catAnimation7 {
            self.animationImages = [image1, image2, image3, image4, image5, image6, image7,
                                    image6, image5, image4, image3, image2, image1]
        }

        self.animationDuration = Numbers.blinkingAnimationDuration
        self.animationRepeatCount = Numbers.blinkingRepeat
    }
    
    func startBlinking() {
        self.startAnimating()
    }
}

