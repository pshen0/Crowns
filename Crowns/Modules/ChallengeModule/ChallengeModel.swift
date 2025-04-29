//
//  ChallengeRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

// MARK: - ChallengeModel
enum ChallengeModel {
    enum RouteCrownsGame {
        struct Request { }
        struct Response { }
    }
    
    enum RouteSudokuGame {
        struct Request { }
        struct Response { }
    }
    
    enum GetStreak {
        struct Request { }
        struct Response { 
            let daysNumber: Int
        }
        struct ViewModel {
            let streakLabel: String
        }
    }
    
    enum ResetChallenges {
        struct Request { }
        struct Response { 
            let crownsAccessibility: Bool
            let sudokusAccessibility: Bool
        }
        struct ViewModel { 
            let crownsAccessibility: Bool
            let sudokusAccessibility: Bool
        }
    }
}
