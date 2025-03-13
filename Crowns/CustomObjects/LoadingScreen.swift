//
//  LoadingScreen.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import UIKit

final class LoadingScreen: UIViewController {
    
    private let startPlayCat: UIImageView = UIImageView(image: Images.startPlayCat)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
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
