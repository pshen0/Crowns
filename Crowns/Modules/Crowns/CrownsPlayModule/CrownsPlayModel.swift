//
//  CrownsPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

enum CrownsPlayModel {
    enum BuildModule {
        struct BuildFoundation {
            let crowns: Crowns
            let elapsedTime: Int
            let initialTime: Int
            let isTimerUsed: Bool
            let placements: [[Int]]
        }
    }
    
    enum  RouteBack {
        struct Request { }
        struct Response { }
    }
    
    enum  GetTable {
        struct Request { }
    }
    
    enum  GetPlacements {
        struct Request { }
    }
    
    enum CheckGameOver {
        struct Request { }
    }
    
    enum RouteGameOver {
        struct Request { }
        struct Response {
            let isWin: Bool
            let time: Int
        }
    }
    
    enum SetTime {
        struct Response {
            let time: Int
        }
        struct ViewModel {
            let timerLabel: String
        }
    }
    
    enum PlaceCrown {
        struct Request {
            let row: Int
            let col: Int
            let isPlaced: Int
        }
    }
    
    enum LeaveGame {
        struct Request { }
    }
    
    enum PauseGame {
        struct Request { }
    }
    
    enum GameIsWon {
        struct Request { }
    }
    
    enum StartTimer {
        struct Request { }
    }
    
    enum GetHint {
        struct Request { }
        struct Response {
            let row: Int
            let col: Int
            let color: UIColor
        }
    }
    
    enum UndoMove {
        struct Request { }
        struct Response {
            let move: CrownsMove
            let color: UIColor
        }
    }
    
    enum UpdateCrownsPlayground {
        struct ViewModel {
            let indexPath: IndexPath
            let color: UIColor
            let mode: String
            let value: Int
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
    
    enum SaveMove {
        struct Request {
            let move: CrownsMove
        }
    }
}

