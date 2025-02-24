//
//  ChallengePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

protocol ChallengePresentationLogic {
    func routeCrownsGame(_ response: ChallengeModel.RouteCrownsGame.Response)
    func routeSudokuGame(_ response: ChallengeModel.RouteSudokuGame.Response)
}

final class ChallengePresenter: ChallengePresentationLogic {
    
    weak var view: ChallengeViewController?
    
    func routeCrownsGame(_ response: ChallengeModel.RouteCrownsGame.Response) {
        view?.navigationController?.pushViewController(CrownsPlayBuilder.build(), animated: false)
    }
    
    func routeSudokuGame(_ response: ChallengeModel.RouteSudokuGame.Response) {
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(), animated: false)
    }
}
