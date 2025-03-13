//
//  SudokuPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

enum SudokuPlayModel {
    
    enum BuildModule {
        struct BuildFoundation {
            let difficultyLevel: String
        }
    }
    
    enum  RouteBack {
        struct Request { }
        struct Response { }
    }
    
    enum ChangeCell {
        struct Request {
            let index: Int
        }
        struct Response {
            let index: Int
        }
        struct ViewModel {
            let arrayRow: Int
            let arrayCol: Int
            let blockIndexPath: IndexPath
            var blockIndex: Int
            var cellIndex: Int
        }
    }
    
    enum RouteGameOver {
        struct Request {
            let isWin: Bool
        }
        struct Response {
            let isWin: Bool
        }
    }
}
