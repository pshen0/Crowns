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
        let difficultyLevel: String = [Text.easyTag, Text.mediumTag, Text.hardTag].randomElement() ?? Text.easyTag
        view?.navigationController?.pushViewController(CrownsPlayBuilder.build(CrownsPlayModel.BuildModule.BuildFoundation(difficultyLevel: difficultyLevel, time: CrownsPlayModel.Time(minutes: Numbers.challengeTimerMinutes, seconds: 0))), animated: false)
    }
    
    func routeSudokuGame(_ response: ChallengeModel.RouteSudokuGame.Response) {
        let difficultyLevel: String = [Text.easyTag, Text.mediumTag, Text.hardTag].randomElement() ?? Text.easyTag
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(SudokuPlayModel.BuildModule.BuildFoundation(difficultyLevel: difficultyLevel, time: SudokuPlayModel.Time(minutes: Numbers.challengeTimerMinutes, seconds: 0))), animated: false)
    }
}
