//
//  Constants.swift
//  Crowns
//
//  Created by Анна Сазонова on 23.01.2025.
//

import UIKit

enum Colors {
    static let darkGray: UIColor = UIColor(hex: "1E1E1E", alpha: 1.0)
    static let lightGray: UIColor = UIColor(hex: "2E2E2E", alpha: 1.0)
    static let yellow: UIColor = UIColor(hex: "FEBE17", alpha: 1.0)
    static let white: UIColor = UIColor(hex: "FFFFFF", alpha: 1.0)
    
}

enum Images {
    // Common
    static let backButton: UIImage? = UIImage(named: "backButton")
    static let backButtonTap: UIImage? = UIImage(named: "backButtonTap")
    
    // MainTabBar
    static let homeBar: UIImage? = UIImage(named: "homeBar")
    static let challengeBar: UIImage? = UIImage(named: "challengeBar")
    static let profileBar: UIImage? = UIImage(named: "profileBar")
    
    // GameSettingsView
    static let startPlayButton: UIImage? = UIImage(named: "startPlayButton")
    static let startPlayButtonTap: UIImage? = UIImage(named: "startPlayButtonTap")
    static let levelEasyButton: UIImage? = UIImage(named: "levelEasyButton")
    static let levelEasyButtonTap: UIImage? = UIImage(named: "levelEasyButtonTap")
    static let levelMediumButton: UIImage? = UIImage(named: "levelMediumButton")
    static let levelMediumButtonTap: UIImage? = UIImage(named: "levelMediumButtonTap")
    static let levelHardButton: UIImage? = UIImage(named: "levelHardButton")
    static let levelHardButtonTap: UIImage? = UIImage(named: "levelHardButtonTap")
    static let levelRandomButton: UIImage? = UIImage(named: "levelRandomButton")
    static let levelRandomButtonTap: UIImage? = UIImage(named: "levelRandomButtonTap")
    
    //ChallengeView
    static let lightning1: UIImage? = UIImage(named: "lightning1")
    static let lightning2: UIImage? = UIImage(named: "lightning2")
    static let challengeMice: UIImage? = UIImage(named: "challengeMice")
    static let cat1: UIImage? = UIImage(named: "cat1")
    static let cat2: UIImage? = UIImage(named: "cat2")
    static let cat3: UIImage? = UIImage(named: "cat3")
    static let cat4: UIImage? = UIImage(named: "cat4")
    static let cat5: UIImage? = UIImage(named: "cat5")
    static let cat6: UIImage? = UIImage(named: "cat6")
    static let cat7: UIImage? = UIImage(named: "cat7")
    static let challengeCrownsButton: UIImage? = UIImage(named: "challengeCrownsButton")
    static let challengeCrownsButtonTap: UIImage? = UIImage(named: "challengeCrownsButtonTap")
    static let challengeSudokuButton: UIImage? = UIImage(named: "challengeSudokuButton")
    static let challengeSudokuButtonTap: UIImage? = UIImage(named: "challengeSudokuButtonTap")
    static let challengeCompletedLevel: UIImage? = UIImage(named: "challengeCompletedLevel")
    static let challengeCompletedLevelTap: UIImage? = UIImage(named: "challengeCompletedLevelTap")
    static let challengeCalendar: UIImage? = UIImage(named: "challengeCalendar")
    
    // HomeView
    static let homeLogoPicture: UIImage? = UIImage(named: "homeLogoPicture")
    static let newGameButton: UIImage? = UIImage(named: "newGameButton")
    static let newGameButtonTap: UIImage? = UIImage(named: "newGameButtonTap")
    static let continueButton: UIImage? = UIImage(named: "continueButton")
    static let continueButtonTap: UIImage? = UIImage(named: "continueButtonTap")
    static let learningButton: UIImage? = UIImage(named: "learningButton")
    static let learningButtonTap: UIImage? = UIImage(named: "learningButtonTap")
    static let homeCalendar: UIImage? = UIImage(named: "homeCalendar")
    static let chooseCrownsButton: UIImage? = UIImage(named: "chooseCrownsButton")
    static let chooseCrownsButtonTap: UIImage? = UIImage(named: "chooseCrownsButtonTap")
    static let chooseSudokuButton: UIImage? = UIImage(named: "chooseSudokuButton")
    static let chooseSudokuButtonTap: UIImage? = UIImage(named: "chooseSudokuButtonTap")
    static let chooseQueensButton: UIImage? = UIImage(named: "chooseQueensButton")
    static let chooseQueensButtonTap: UIImage? = UIImage(named: "chooseQueensButtonTap")
    

    
}

enum Numbers {
    // Common
    static let crownsTag: Int = 1
    static let sudokuTag: Int = 2
    static let queensTag: Int = 3
    
    // ChallengeView
    static let lightningBackVisible: Double  = 0.2
    static let lightningAnimationUnvisible: Double = 0
    static let lightningAnimationVisible: Double = 1
    static let lightningAnimationDuration: Double = 8.0
    static let lightningAppearanceDuration: Double = 0.5
    
    // MainTabBar
    static let tabBarSelectedIndex: Int = 1
    
    // HomeView
    static let overlayVisible: Double = 0.7
    static let overlayUnvisible: Double = 0
    static let gameSelectorAnimationDuration: TimeInterval = 0.3
    static let gameSelectorShadowVisible: Float = 0.3
    static let gameSelectorShadowUnvisible: Float = 0
    static let newGameButtonTag: Int = 1
    static let learningButtonTag: Int = 2
    
    // BlinkingCat
    static let blinkingAnimationDuration: Double = 0.6
    static let blinkingRepeat: Int = 1
    
    // GameSettingsView
    static let levelEasyTag: Int = 1
    static let levelMediumTag: Int = 2
    static let levelHardTag: Int = 3
    static let levelRandomTag: Int = 4
}

enum Text {
    // Common
    static let initError: String = "init(coder:) has not been implemented"
    static let crownsGame: String = "Crowns"
    static let sudokuGame: String = "Killer-sudoku"
    static let queensGame: String = "N Queens problem"
    static let fontIrishGrover: String = "IrishGrover-Regular"
    
    // MainTabBar
    static let homeTabBar: String = "Home"
    static let challengeTabBar: String = "Challenges"
    static let profileTabBar: String = "Profile"
    
    // HomeView
    static let homeLogo: String = "CROWNS"
    static let chooseGame: String = "Choose game:"
    static let chooseLearning: String = "Choose learning:"
    
    // ChallengeView
    static let challengeLogo: String = "The daily challenge\nCAT AND MOUSE"
    
    // GameSettingsView
    static let chooseDifficulty: String = "Choose the difficulty level:"
    static let chooseFieldsSize: String = "Set the field size:"
}

enum Constraints {
    // Common
    static let textSize: CGFloat = 17
    
    // HomeView
    static let homeLogoPictureTop: CGFloat = 0
    static let homeLogoTextTop: CGFloat = 5
    static let homeLogoSize: CGFloat = 75
    static let homeCalendarTop: CGFloat = 45
    static let newGameButtonTop: CGFloat = 45
    static let continueButtonTop: CGFloat = 15
    static let learningButtonTop: CGFloat = 15
    static let tabBarItemIndentation: CGFloat = 10
    static let gameSelectorHeight: CGFloat = 370
    static let gameSelectorRadius: CGFloat = 16
    static let gameSelectorShadowHeight: CGFloat = 20
    static let gameSelectorShadowWidth: CGFloat = 0
    static let gameSelectorShadowRadius: CGFloat = 16
    static let chooseCrownsButtonTop: CGFloat = 75
    static let chooseSudokuButtonTop: CGFloat = 15
    static let chooseQueensButtonTop: CGFloat = 15
    static let chooseTextTop: CGFloat = 25
    static let selectorTextSize: CGFloat = 25
    
    // ChallengeView
    static let challengeLogoTextTop: CGFloat = 5
    static let challengeLogoSize: CGFloat = 35
    static let lightning1Top: CGFloat = -30
    static let lightning2Top: CGFloat = -40
    static let lightning1Left: CGFloat = -50
    static let lightning2Right: CGFloat = -20
    static let lightningAnimation1Top: CGFloat = -40
    static let lightningAnimation2Top: CGFloat = -50
    static let lightningAnimation1Left: CGFloat = 210
    static let lightningAnimation2Right: CGFloat = 210
    static let challengeCatTop: CGFloat = 130
    static let challengeCatLeft: CGFloat = 10
    static let challengeMiceTop: CGFloat = 160
    static let challengeMiceRight: CGFloat = 20
    static let challengeCalendarTop: CGFloat = 35
    static let challengeCrownsButtonTop: CGFloat = 35
    static let challengeSudokuButtonTop: CGFloat = 15
    
    // GameSettingsView
    static let gameLogoSize: CGFloat = 34
    static let startPlayButtonBottom: CGFloat = 30
    static let gameLogoTop: CGFloat = 0
    static let settingsTextSize: CGFloat = 24
    static let choosingDifficultyTextTop: CGFloat = 25
}


