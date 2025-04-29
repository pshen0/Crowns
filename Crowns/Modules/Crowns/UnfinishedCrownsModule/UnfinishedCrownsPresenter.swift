//
//  UnfinishedCrownsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

// MARK: - UnfinishedCrownsPresentationLogic protocol
protocol UnfinishedCrownsPresentationLogic {
    func getDescriptionLabels(_ response: UnfinishedCrownsModel.AddDescription.Response)
}

// MARK: - UnfinishedCrownsPresenter class
final class UnfinishedCrownsPresenter: UnfinishedCrownsPresentationLogic {
    // MARK: - Properties
    weak var view: UnfinishedCrownsViewController?
    
    // MARK: - Funcs
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
    
    // MARK: - Constants
    private enum Constants {
        static let difficultyLabel = "Difficulty: "
        static let timeLabel = "Time spent: "
    }
}
