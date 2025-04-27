//
//  UnfinishedSudokuPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

protocol UnfinishedSudokuPresentationLogic {
    func getDescriptionLabels(_ response: UnfinishedSudokuModel.AddDescription.Response)
}

final class UnfinishedSudokuPresenter: UnfinishedSudokuPresentationLogic {
    
    weak var view: UnfinishedSudokuViewController?
    
    func getDescriptionLabels(_ response: UnfinishedSudokuModel.AddDescription.Response) {
        let difficultyLabel = "Difficulty: \(response.difficulty)"
        let minutes = response.time / 60
        let minutesString = minutes > 9 ? String(minutes) : "0\(minutes)"
        let seconds = response.time % 60
        let secondsString = seconds > 9 ? String(seconds) : "0\(seconds)"
        let timeLabel = "Time spent: \(minutesString):\(secondsString)"
        view?.configureDescription(UnfinishedSudokuModel.AddDescription.ViewModel(
            difficultyLabel: difficultyLabel,
            timeLabel: timeLabel))
    }
    
    func routeToGame(_ response: UnfinishedSudokuModel.ContinueTheGame.Response) {
        
    }
}
