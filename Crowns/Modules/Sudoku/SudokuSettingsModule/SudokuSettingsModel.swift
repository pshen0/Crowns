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
        }
        struct Response { 
            let difficultyLevel: String
        }
    }
    
    enum RouteBack {
        struct Request { }
        struct Response { }
    }
}
