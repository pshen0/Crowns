//
//  UnfinishedSudokuPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

// MARK: - UnfinishedSudokuPresentationLogic protocol
protocol UnfinishedSudokuPresentationLogic {
    func getDescriptionLabels(_ response: UnfinishedSudokuModel.AddDescription.Response)
}

// MARK: - UnfinishedSudokuPresenter class
final class UnfinishedSudokuPresenter: UnfinishedSudokuPresentationLogic {
    
    // MARK: - Properties
    weak var view: UnfinishedSudokuViewController?
    
    // MARK: - Funcs
    func getDescriptionLabels(_ response: UnfinishedSudokuModel.AddDescription.Response) {
        let difficultyLabel = Constants.difficultyLabel + String(response.difficulty)
        let minutes = response.time / 60
        let minutesString = minutes > 9 ? String(minutes) : "0\(minutes)"
        let seconds = response.time % 60
        let secondsString = seconds > 9 ? String(seconds) : "0\(seconds)"
        let timeLabel = "\(Constants.timeLabel) \(minutesString):\(secondsString)"
        view?.configureDescription(UnfinishedSudokuModel.AddDescription.ViewModel(
            difficultyLabel: difficultyLabel,
            timeLabel: timeLabel))
    }
    
    func routeToGame(_ response: UnfinishedSudokuModel.ContinueTheGame.Response) {
        
    }
    
    // MARK: - Constants
    private enum Constants {
        static let difficultyLabel = "Difficulty: "
        static let timeLabel = "Time spent: "
    }
}
