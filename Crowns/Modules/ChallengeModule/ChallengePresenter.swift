//
//  ChallengePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

// MARK: - ChallengePresentationLogic protocol
protocol ChallengePresentationLogic {
    func routeCrownsGame(_ response: ChallengeModel.RouteCrownsGame.Response)
    func routeSudokuGame(_ response: ChallengeModel.RouteSudokuGame.Response)
    func changeButtonsAccessibility(_ response: ChallengeModel.ResetChallenges.Response)
    func presentStreakLabel(_ response: ChallengeModel.GetStreak.Response)
}

// MARK: - ChallengePresenter class
final class ChallengePresenter: ChallengePresentationLogic {
    // MARK: - Properties
    weak var view: ChallengeViewController?
    
    // MARK: - Funcs
    func routeCrownsGame(_ response: ChallengeModel.RouteCrownsGame.Response) {
        let difficultyLevel = getDifficultyLevel()
        let crownsFoundation: CrownsPlayModel.BuildModule.BuildFoundation = CrownsPlayModel.BuildModule.BuildFoundation(
            crowns: Crowns(difficultyLevel),
            elapsedTime: Constants.elapsedTime,
            initialTime: Constants.initialTime,
            isTimerUsed: Constants.isTimerUsed,
            placements: Array(repeating: Array(repeating: 0, count: Constants.arraySize), count: Constants.arraySize))
        view?.navigationController?.pushViewController(CrownsPlayBuilder.build(crownsFoundation), animated: false)
    }
    
    func routeSudokuGame(_ response: ChallengeModel.RouteSudokuGame.Response) {
        let difficultyLevel = getDifficultyLevel()
        let sudokuFoundation = SudokuPlayModel.BuildModule.BuildFoundation(
            killerSudoku: KillerSudoku(difficultyLevel: difficultyLevel),
            elapsedTime: Constants.elapsedTime,
            initialTime: Constants.initialTime,
            isTimerUsed: Constants.isTimerUsed)
        view?.navigationController?.pushViewController(SudokuPlayBuilder.build(sudokuFoundation), animated: false)
    }
    
    func changeButtonsAccessibility(_ response: ChallengeModel.ResetChallenges.Response) {
        view?.updateScreen(ChallengeModel.ResetChallenges.ViewModel(
            crownsAccessibility: response.crownsAccessibility,
            sudokusAccessibility: response.sudokusAccessibility))
    }
    
    func presentStreakLabel(_ response: ChallengeModel.GetStreak.Response) {
        let streakLabel = Constants.streakLogo + String(response.daysNumber) + Constants.crownEmoji
        view?.changeStreakLabel(ChallengeModel.GetStreak.ViewModel(streakLabel: streakLabel))
    }
    
    // MARK: - Private funcs
    private func getDifficultyLevel() -> String {
        if let level = [DifficultyLevels.easy, DifficultyLevels.medium, DifficultyLevels.hard].randomElement() {
            return level
        } else {
            return DifficultyLevels.easy
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        static let elapsedTime = 0
        static let initialTime = 5 * 60
        static let arraySize = 9
        
        static let isTimerUsed = true
        
        static let streakLogo = "Current streak: "
        static let crownEmoji = " 👑"
        
    }
}
