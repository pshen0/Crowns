//
//  UnfinishedCrownsInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

protocol UnfinishedCrownsBusinessLogic {
    func getDiscriptionParametrs(_ request: UnfinishedCrownsModel.AddDiscription.Request)
    func deleteProgress(_ request: UnfinishedCrownsModel.DeleteProgress.Request)
    func getCrownsFoundation() -> CrownsPlayModel.BuildModule.BuildFoundation
}

final class UnfinishedCrownsInteractor: UnfinishedCrownsBusinessLogic {
    
    private let presenter: UnfinishedCrownsPresentationLogic
    private let foundation: UnfinishedCrownsModel.BuildModule.BuildFoundation
    
    init(presenter: UnfinishedCrownsPresentationLogic, foundation: UnfinishedCrownsModel.BuildModule.BuildFoundation) {
        self.presenter = presenter
        self.foundation = foundation
    }
    
    func getDiscriptionParametrs(_ request: UnfinishedCrownsModel.AddDiscription.Request) {
        presenter.getDiscriptionLabels(UnfinishedCrownsModel.AddDiscription.Response(
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
