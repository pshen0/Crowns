//
//  LoadingScreen.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import UIKit

// MARK: - LoadingScreen class
final class LoadingScreen: UIViewController {
    
    // MARK: - Properties
    private let startPlayCat: UIImageView = UIImageView(image: UIImage.startPlayCat)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        activityIndicator.stopAnimating()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Errors.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        view.backgroundColor = Colors.darkGray
        
        for subview in [startPlayCat, activityIndicator] {
            view.addSubview(subview)
            subview.pinCenterX(to: view)
        }
        
        startPlayCat.pinCenterY(to: view)
        activityIndicator.pinTop(to: startPlayCat.bottomAnchor, 20)
        activityIndicator.startAnimating()
    }
}
