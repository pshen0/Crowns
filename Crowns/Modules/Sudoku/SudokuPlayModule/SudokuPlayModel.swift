//
//  SudokuPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

enum SudokuPlayModel {
    
    struct SudokuMove {
        let index: Int
        let value: Int
    }
    
    enum StartTimer {
        struct Request { }
    }
    
    enum BuildModule {
        struct BuildFoundation {
            let killerSudoku: KillerSudoku
            let elapsedTime: Int
            let initialTime: Int
            let isTimerUsed: Bool
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
    }
    
    enum ChangeCell {
        struct Change {
            let blockIndex: IndexPath
            let cellIndex: IndexPath
            let number: Int
            let mode: String
        }
        
        struct Response {
            let changes: [Change]
        }
        
        struct ViewModel {
            let changes: [Change]
        }
    }
    
    enum DeleteCellNumber {
        struct Request {
            let index: Int
        }
    }
    
    enum CheckGameOver {
        struct Request { }
    }
    
    enum CheckChallenge {
        struct Request { }
    }
    
    enum RouteGameOver {
        struct Request { }
        struct Response {
            let isWin: Bool
            let time: Int
        }
    }
    
    enum GetHint {
        struct Request { }
        struct Response {
            let row: Int
            let col: Int
            let color: UIColor
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
            let initData: [Int]
        }
    }
    
    enum GameIsWon {
        struct Request { }
    }
    
    enum SetTime {
        struct Response {
            let time: Int
        }
        struct ViewModel {
            let timerLabel: String
        }
    }
    
    enum LeaveGame {
        struct Request { }
    }
    
    enum PauseGame {
        struct Request { }
    }
    
    enum UndoMove {
        struct Request { }
        struct Response {
            let move: SudokuMove
        }
    }
    
    enum SaveMove {
        struct Request {
            let index: Int
        }
    }
    
    enum GetLevel {
        struct Request { }
        struct Response {
            let image: UIImage?
        }
        struct ViewModel {
            let image: UIImage?
        }
    }
}
