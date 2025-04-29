//
//  StatisticsModel.swift
//  Crowns
//
//  Created by Анна Сазонова on 04.03.2025.
//

import Foundation

// MARK: - StatisticsModel enum
enum StatisticsModel {
    
    enum GameType {
        case crowns
        case killerSudoku
    }

    struct StatisticItem {
        let title: String
        let value: String
    }
    
    enum RouteBack {
        struct Request { }
        struct Response { }
    }
    
    enum OpenStatistics {
        struct Request { }
        struct Response { 
            let gameType: GameType
        }
        struct ViewModel { 
            let gameType: GameType
        }
    }
}
