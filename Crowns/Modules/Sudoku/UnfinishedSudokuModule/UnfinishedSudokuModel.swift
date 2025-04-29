//
//  UnfinishedSudokuModel.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

// MARK: - UnfinishedSudokuModel enum
enum UnfinishedSudokuModel {
    enum BuildModule {
        struct BuildFoundation {
            let killerSudoku: KillerSudoku
            let elapsedTime: Int
            let initialTime: Int
            let isTimerUsed: Bool
        }
    }
    
    enum AddDescription {
        struct Request { }
        struct Response {
            let difficulty: String
            let time: Int
        }
        struct ViewModel {
            let difficultyLabel: String
            let timeLabel: String
        }
    }
    
    enum DeleteProgress {
        struct Request { }
    }
    
    enum ContinueTheGame {
        struct Request { }
        struct Response {
            let foundation: BuildModule.BuildFoundation
        }
    }
}
