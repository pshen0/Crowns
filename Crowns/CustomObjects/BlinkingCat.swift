//
//  BlinkingCat.swift
//  Crowns
//
//  Created by Анна Сазонова on 21.02.2025.
//

import UIKit

// MARK: - BlinkingCatView class
final class BlinkingCatView: UIImageView {
    
    // MARK: - Properties
    private let animationFrames: [UIImage?]
    
    // MARK: - Lifecycle
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
    
    // MARK: - Funcs
    func startBlinking() {
        self.startAnimating()
    }
    
    func stopBlinking() {
        self.stopAnimating()
    }
    
    // MARK: - Private funcs
    private func setupAnimation(duration: TimeInterval, repeatCount: Int) {
        if let image = animationFrames.first {
            self.image = image
        }
        self.animationImages = animationFrames.compactMap { $0 }
        self.animationDuration = duration
        self.animationRepeatCount = repeatCount
    }
}
