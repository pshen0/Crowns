//
//  CrownsPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

enum CrownsPlayModel {
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
    
    enum  GetTable {
        struct Request { }
    }
    
    enum CheckGameOver {
        struct Request {
            let crownsPlacements: [[Bool]]
        }
    }
    
    enum RouteGameOver {
        struct Request { }
        struct Response {
            let isWin: String
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

