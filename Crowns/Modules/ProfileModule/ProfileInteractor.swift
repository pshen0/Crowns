//
//  File.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation

protocol ProfileBusinessLogic {
    
}

final class ProfileInteractor: ProfileBusinessLogic {
    
    private let presenter: ProfilePresentationLogic
    
    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }
}
