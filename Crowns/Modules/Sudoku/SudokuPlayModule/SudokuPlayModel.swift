//
//  SudokuPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

enum SudokuPlayModel {
    struct Time {
        var minutes: Int
        var seconds: Int
    }
    
    enum BuildModule {
        struct BuildFoundation {
            let difficultyLevel: String
            let time: Time
        }
    }
    
    enum  RouteBack {
        struct Request { }
        struct Response { }
    }
    
    enum ChangeCellNumber {
        struct Request {
            let index: Int
            let number: Int
        }

        struct ViewModel {
            let blockIndex: IndexPath
            let cellIndex: IndexPath
            let number: Int
            let mode: String
        }
    }
    
    enum DeleteCellNumber {
        struct Request {
            let index: Int
        }

        struct ViewModel {
            let blockIndex: IndexPath
            let cellIndex: IndexPath
            let number: Int
            let mode: String
        }
    }
    
    enum CheckGameOver {
        struct Request { }
    }
    
    enum RouteGameOver {
        struct Request { }
        struct Response {
            let isWin: Bool
        }
    }
    
    enum GetCages {
        struct Request { }
    }
    
    enum DetermineCellsWithSum {
        struct Request {
            let index: Int
        }
        struct ViewModel {
            let cellsWithSum: [(IndexPath, Int)]
            let blockData: [Int]
        }
    }
    
    enum SetTime {
        struct Response {
            let time: Time
        }
        struct ViewModel {
            let timerLabel: String
        }
    }
    
    enum PauseGame {
        struct Request { }
    }
}
