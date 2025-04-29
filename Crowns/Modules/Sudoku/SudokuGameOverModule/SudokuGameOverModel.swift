//
//  SudokuGameOverModel.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import Foundation

// MARK: - SudokuGameOverModel enum
enum SudokuGameOverModel {
    enum RouteHome {
        struct Request { }
        struct Response { }
    }
    
    enum RouteStatistics {
        struct Request { }
        struct Response { }
    }
    
    enum IsWin {
        struct Request { }
    }
    
    enum getTime {
        struct Request { }
    }
}
