//
//  BlinkingCat.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

final class BlinkingCatView: UIImageView {
    
    private let animationFrames: [UIImage?]
    
    init(images: [UIImage?], duration: TimeInterval, repeatCount: Int) {
        self.animationFrames = images + images.reversed()
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
    
    func startBlinking() {
        self.startAnimating()
    }
    
    func stopBlinking() {
        self.stopAnimating()
    }
}
