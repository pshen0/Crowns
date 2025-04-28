//
//  UnfinishedCrownsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

protocol UnfinishedCrownsPresentationLogic {
    func getDescriptionLabels(_ response: UnfinishedCrownsModel.AddDescription.Response)
}

final class UnfinishedCrownsPresenter: UnfinishedCrownsPresentationLogic {
    
    weak var view: UnfinishedCrownsViewController?
    
    func getDescriptionLabels(_ response: UnfinishedCrownsModel.AddDescription.Response) {
        let difficultyLabel = Constants.difficultyLabel + String(response.difficulty)
        let minutes = response.time / 60
        let minutesString = minutes > 9 ? String(minutes) : "0\(minutes)"
        let seconds = response.time % 60
        let secondsString = seconds > 9 ? String(seconds) : "0\(seconds)"
        let timeLabel = "\(Constants.timeLabel) \(minutesString):\(secondsString)"
        view?.configureDescription(UnfinishedCrownsModel.AddDescription.ViewModel(
            difficultyLabel: difficultyLabel,
            timeLabel: timeLabel))
    }
    
    func routeToGame(_ response: UnfinishedCrownsModel.ContinueTheGame.Response) {
        
    }
    
    private enum Constants {
        static let difficultyLabel = "Difficulty: "
        static let timeLabel = "Time spent: "
    }
}
