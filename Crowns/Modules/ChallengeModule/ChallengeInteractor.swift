//
//  ChallengeInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

protocol ChallengeBusinessLogic {
    func crownsButtonTapped(_ request: ChallengeModel.RouteCrownsGame.Request)
    func sudokuButtonTapped(_ request: ChallengeModel.RouteSudokuGame.Request)
}

final class ChallengeInteractor: ChallengeBusinessLogic {
    
    private let presenter: ChallengePresentationLogic
    
    init(presenter: ChallengePresentationLogic) {
        self.presenter = presenter
    }
    
    func crownsButtonTapped(_ request: ChallengeModel.RouteCrownsGame.Request) {
        presenter.routeCrownsGame(ChallengeModel.RouteCrownsGame.Response())
    }
    
    func sudokuButtonTapped(_ request: ChallengeModel.RouteSudokuGame.Request) {
        presenter.routeSudokuGame(ChallengeModel.RouteSudokuGame.Response())
    }
}
