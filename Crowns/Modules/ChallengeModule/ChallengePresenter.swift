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
        let crownsFoundation: CrownsPlayModel.BuildModule.BuildFoundation = CrownsPlayModel.BuildModule.BuildFoundation(
            crowns: Crowns(difficultyLevel),
            elapsedTime: 0,
            initialTime: 5 * 60,
            isTimerUsed: true,
            placements: Array(repeating: Array(repeating: 0, count: 9), count: 9))
        view?.navigationController?.pushViewController(CrownsPlayBuilder.build(crownsFoundation), animated: false)
    }
    
    func routeSudokuGame(_ response: ChallengeModel.RouteSudokuGame.Response) {
        let difficultyLevel: String = [Text.easyTag, Text.mediumTag, Text.hardTag].randomElement() ?? Text.easyTag
        let sudokuFoundation = SudokuPlayModel.BuildModule.BuildFoundation(
            killerSudoku: KillerSudoku(difficultyLevel: difficultyLevel),
            elapsedTime: 0,
            initialTime: 5 * 60,
            isTimerUsed: true)
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(sudokuFoundation), animated: false)
    }
}
