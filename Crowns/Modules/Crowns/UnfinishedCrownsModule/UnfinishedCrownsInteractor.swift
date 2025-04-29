//
//  UnfinishedCrownsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

// MARK: - UnfinishedCrownsBusinessLogic protocol
protocol UnfinishedCrownsBusinessLogic {
    func getDescriptionParametrs(_ request: UnfinishedCrownsModel.AddDescription.Request)
    func deleteProgress(_ request: UnfinishedCrownsModel.DeleteProgress.Request)
    func getCrownsFoundation() -> CrownsPlayModel.BuildModule.BuildFoundation
}

// MARK: - UnfinishedCrownsInteractor class
final class UnfinishedCrownsInteractor: UnfinishedCrownsBusinessLogic {
    // MARK: - Properties
    private let presenter: UnfinishedCrownsPresentationLogic
    private let foundation: UnfinishedCrownsModel.BuildModule.BuildFoundation
    
    // MARK: - Lifecycle
    init(presenter: UnfinishedCrownsPresentationLogic, foundation: UnfinishedCrownsModel.BuildModule.BuildFoundation) {
        self.presenter = presenter
        self.foundation = foundation
    }
    
    // MARK: - Funcs
    func getDescriptionParametrs(_ request: UnfinishedCrownsModel.AddDescription.Request) {
        presenter.getDescriptionLabels(UnfinishedCrownsModel.AddDescription.Response(
            difficulty: foundation.crowns.difficultyLevel,
            time: foundation.elapsedTime))
    }
    
    func deleteProgress(_ request: UnfinishedCrownsModel.DeleteProgress.Request) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.unfinishedCrownsGame)
        CoreDataCrownsProgressStack.shared.deleteAllProgress()
    }
    
    func getCrownsFoundation() -> CrownsPlayModel.BuildModule.BuildFoundation {
        return CrownsPlayModel.BuildModule.BuildFoundation(
            crowns: foundation.crowns,
            elapsedTime: foundation.elapsedTime,
            initialTime: foundation.initialTime,
            isTimerUsed: foundation.isTimerUsed,
            placements: foundation.placements)
    }
}
