//
//  Constants.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit

// MARK: - Core data constants
enum CoreData {
    static let loadError = "Ошибка загрузки"
    static let deleteError = "Ошибка удаления"
    static let saveError = "Ошибка сохранения"
    static let containerName = "GameModel"
}

// MARK: - User defaults constants
enum UserDefaultsKeys {
    static let unfinishedCrownsGame = "UnfinishedCrownsGame"
    static let unfinishedSudokuGame = "UnfinishedSudokuGame"
    static let crownsChallengeAvailable = "CrownsChallengeAvailable"
    static let sudokuChallengeAvailable = "SudokuChallengeAvailable"
    static let crownsChallengeGoes = "CrownsChallengeGoes"
    static let sudokuChallengeGoes = "SudokuChallengeGoes"
    static let crownsChallengeDone = "CrownsChallengeDone"
    static let sudokuChallengeDone = "SudokuChallengeDone"
    static let lastResetDate = "LastResetDate"
}

// MARK: - Difficulty labels
enum DifficultyLevels {
    static let easy = "Easy"
    static let medium = "Medium"
    static let hard = "Hard"
}

// MARK: - Statistics fields
enum StatisticsFields {
    static let all = "Games started"
    static let allWin = "Games won"
    static let easyWin = "Games won: easy"
    static let mediumWin = "Games won: medium"
    static let hardWin = "Games won: hard"
    static let winRate = "Win rate"
    static let bestTime = "The best time"
    static let averageTime = "The average time"
}

// MARK: - Fonts
enum Fonts {
    static let IrishGrover: String = "IrishGrover-Regular"
}

// MARK: - Crowns cell contents
enum CrownsCellContent {
    static let empty = 0
    static let cross = 1
    static let crown = 2
}

// MARK: - Crowns cell modes
enum CrownsCellMode {
    static let inition = "inition"
    static let reload = "reload"
    static let hint = "hint"
    static let undo = "undo"
}

// MARK: - Sudoku cell modes
enum SudokuCellMode {
    static let inition = "inition"
    static let correct = "correct"
    static let incorrect = "incorrect"
}

// MARK: - Custom cell IDs
enum CellsID {
    static let sudokuCellId = "KillerSudokuCell"
    static let crownsCellId = "CrownsCell"
    static let statisticCellId = "StatisticCell"
}

// MARK: - Error messages
enum Errors {
    static let initErrorCoder: String = "init(coder:) has not been implemented"
    static let initErrorFrame: String = "init(frame:) has not been implemented"
}

// MARK: - Custom colors
enum Colors {
    enum CrownsColors {
        static let lightBlue: UIColorCodable = UIColorCodable(UIColor(red: 149/255, green: 184/255, blue: 209/255, alpha: 1))
        static let lightGreen: UIColorCodable = UIColorCodable(UIColor(red: 162/255, green: 196/255, blue: 175/255, alpha: 1))
        static let green: UIColorCodable = UIColorCodable(UIColor(red: 131/255, green: 161/255, blue: 100/255, alpha: 1))
        static let blue: UIColorCodable = UIColorCodable(UIColor(red: 97/255, green: 156/255, blue: 211/255, alpha: 1))
        static let yellow: UIColorCodable = UIColorCodable(UIColor(red: 255/255, green: 228/255, blue: 156/255, alpha: 1))
        static let orange: UIColorCodable = UIColorCodable(UIColor(red: 247/255, green: 176/255, blue: 136/255, alpha: 1))
        static let purple: UIColorCodable = UIColorCodable(UIColor(red: 112/255, green: 88/255, blue: 217/255, alpha: 1))
        static let pink: UIColorCodable = UIColorCodable(UIColor(red: 199/255, green: 131/255, blue: 185/255, alpha: 1))
        static let red: UIColorCodable = UIColorCodable(UIColor(red: 253/255, green: 127/255, blue: 116/255, alpha: 1))
        static let clear: UIColorCodable = UIColorCodable(UIColor(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    static let darkGray: UIColor = UIColor(hex: "1E1E1E", alpha: 1.0)
    static let lightGray: UIColor = UIColor(hex: "2E2E2E", alpha: 1.0)
    static let yellow: UIColor = UIColor(hex: "FEBE17", alpha: 1.0)
    static let white: UIColor = UIColor(hex: "FFFFFF", alpha: 1.0)
    static let black = UIColor.black
    
}
