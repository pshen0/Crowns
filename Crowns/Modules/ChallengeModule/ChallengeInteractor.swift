//
//  ChallengeInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

protocol ChallengeBusinessLogic {
    
}

final class ChallengeInteractor: ChallengeBusinessLogic {
    
    private let presenter: ChallengePresentationLogic
    
    init(presenter: ChallengePresentationLogic) {
        self.presenter = presenter
    }
}
