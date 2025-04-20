//
//  UnfinishedCrownsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

protocol UnfinishedCrownsPresentationLogic {
    func getDiscriptionLabels(_ response: UnfinishedCrownsModel.AddDiscription.Response)
}

final class UnfinishedCrownsPresenter: UnfinishedCrownsPresentationLogic {
    
    weak var view: UnfinishedCrownsViewController?
    
    func getDiscriptionLabels(_ response: UnfinishedCrownsModel.AddDiscription.Response) {
        let difficultyLabel = "Difficulty: \(response.difficulty)"
        let minutes = response.time / 60
        let minutesString = minutes > 9 ? String(minutes) : "0\(minutes)"
        let seconds = response.time % 60
        let secondsString = seconds > 9 ? String(seconds) : "0\(seconds)"
        let timeLabel = "Time spent: \(minutesString):\(secondsString)"
        view?.configureDiscription(UnfinishedCrownsModel.AddDiscription.ViewModel(
            difficultyLabel: difficultyLabel,
            timeLabel: timeLabel))
    }
    
    func routeToGame(_ response: UnfinishedCrownsModel.ContinueTheGame.Response) {
        
    }
}
