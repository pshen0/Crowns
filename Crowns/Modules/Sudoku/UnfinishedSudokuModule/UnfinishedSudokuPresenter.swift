//
//  UnfinishedSudokuPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

protocol UnfinishedSudokuPresentationLogic {
    func getDiscriptionLabels(_ response: UnfinishedSudokuModel.AddDiscription.Response)
}

final class UnfinishedSudokuPresenter: UnfinishedSudokuPresentationLogic {
    
    weak var view: UnfinishedSudokuViewController?
    
    func getDiscriptionLabels(_ response: UnfinishedSudokuModel.AddDiscription.Response) {
        let difficultyLabel = "Difficulty: \(response.difficulty)"
        let minutes = response.time / 60
        let minutesString = minutes > 9 ? String(minutes) : "0\(minutes)"
        let seconds = response.time % 60
        let secondsString = seconds > 9 ? String(seconds) : "0\(seconds)"
        let timeLabel = "Time spent: \(minutesString):\(secondsString)"
        view?.configureDiscription(UnfinishedSudokuModel.AddDiscription.ViewModel(
            difficultyLabel: difficultyLabel,
            timeLabel: timeLabel))
    }
    
    func routeToGame(_ response: UnfinishedSudokuModel.ContinueTheGame.Response) {
        
    }
}
