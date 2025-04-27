//
//  UnfinishedSudokuInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

protocol UnfinishedSudokuBusinessLogic {
    func getDescriptionParametrs(_ request: UnfinishedSudokuModel.AddDescription.Request)
    func deleteProgress(_ request: UnfinishedSudokuModel.DeleteProgress.Request)
    func getSudokuFoundation() -> SudokuPlayModel.BuildModule.BuildFoundation
}

final class UnfinishedSudokuInteractor: UnfinishedSudokuBusinessLogic {
    
    private let presenter: UnfinishedSudokuPresentationLogic
    private let foundation: UnfinishedSudokuModel.BuildModule.BuildFoundation
    
    init(presenter: UnfinishedSudokuPresentationLogic, foundation: UnfinishedSudokuModel.BuildModule.BuildFoundation) {
        self.presenter = presenter
        self.foundation = foundation
    }
    
    func getDescriptionParametrs(_ request: UnfinishedSudokuModel.AddDescription.Request) {
        presenter.getDescriptionLabels(UnfinishedSudokuModel.AddDescription.Response(
            difficulty: foundation.killerSudoku.difficultyLevel,
            time: foundation.elapsedTime))
    }
    
    func deleteProgress(_ request: UnfinishedSudokuModel.DeleteProgress.Request) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.unfinishedSudokuGame)
        CoreDataSudokuProgressStack.shared.deleteAllProgress()
    }
    
    func getSudokuFoundation() -> SudokuPlayModel.BuildModule.BuildFoundation {
        return SudokuPlayModel.BuildModule.BuildFoundation(
            killerSudoku: foundation.killerSudoku,
            elapsedTime: foundation.elapsedTime,
            initialTime: foundation.initialTime,
            isTimerUsed: foundation.isTimerUsed)
    }
}
