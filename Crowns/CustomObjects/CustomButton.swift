//
//  CustomButton.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

final class CustomButton: UIButton {
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
        fatalError(Errors.initErrorCoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
