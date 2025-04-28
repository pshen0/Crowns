//
//  JumpingCat.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

final class JumpingCatView: UIImageView {
    
    private let animationFrames: [UIImage?]
    
    init(duration: TimeInterval, repeatCount: Int) {
        self.animationFrames = [UIImage.devCat1, UIImage.devCat2, UIImage.devCat3, UIImage.devCat4,
                                UIImage.devCat3, UIImage.devCat2, UIImage.devCat1, UIImage.devCat5,
                                UIImage.devCat6, UIImage.devCat7, UIImage.devCat6, UIImage.devCat5,
                                UIImage.devCat1]
        super.init(frame: .zero)
        setupAnimation(duration: duration, repeatCount: repeatCount)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Errors.initErrorCoder)
    }
    
    override init(frame: CGRect) {
        fatalError(Errors.initErrorFrame)
    }
    
    private func setupAnimation(duration: TimeInterval, repeatCount: Int) {
        if let image = animationFrames.first {
            self.image = image
        }
        self.animationImages = animationFrames.compactMap { $0 }
        self.animationDuration = duration
        self.animationRepeatCount = repeatCount
    }
    
    func startJumping() {
        self.startAnimating()
    }
    
    func stopJumping() {
        self.stopAnimating()
    }
}
