//
//  SudokuSettingsModel.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation

enum SudokuSettingsModel {
    
    enum RouteSudokuGame {
        struct Request { 
            let buttonTag: Int
            let timerLabel: String
        }
        struct Response { 
            let difficultyLevel: String
            let timerLabel: String
        }
    }
    
    enum RouteBack {
        struct Request { }
        struct Response { }
    }
}
