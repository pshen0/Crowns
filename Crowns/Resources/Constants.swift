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
    static let doneButton: UIImage? = UIImage(named: "doneButton")
    static let doneButtonTap: UIImage? = UIImage(named: "doneButtonTap")
    
    // ProfileView
    static let startAvatarPicture: UIImage? = UIImage(named: "startAvatar")
    static let settingsButton: UIImage? = UIImage(named: "settingsButton")
    static let statisticsButton: UIImage? = UIImage(named: "statisticsButton")
    static let developerButton: UIImage? = UIImage(named: "developerButton")
    
    //ChallengeView
    static let lightning1: UIImage? = UIImage(named: "lightning1")
    static let lightning2: UIImage? = UIImage(named: "lightning2")
    static let challengeMice: UIImage? = UIImage(named: "challengeMice")
    static let challengeBlinkingCat1: UIImage? = UIImage(named: "challengeBlinkingCat1")
    static let challengeBlinkingCat2: UIImage? = UIImage(named: "challengeBlinkingCat2")
    static let challengeBlinkingCat3: UIImage? = UIImage(named: "challengeBlinkingCat3")
    static let challengeBlinkingCat4: UIImage? = UIImage(named: "challengeBlinkingCat4")
    static let challengeBlinkingCat5: UIImage? = UIImage(named: "challengeBlinkingCat5")
    static let challengeBlinkingCat6: UIImage? = UIImage(named: "challengeBlinkingCat6")
    static let challengeBlinkingCat7: UIImage? = UIImage(named: "challengeBlinkingCat7")
    static let blinkingCatArray = [Images.challengeBlinkingCat1, Images.challengeBlinkingCat2, Images.challengeBlinkingCat3, Images.challengeBlinkingCat4,
                                    Images.challengeBlinkingCat5, Images.challengeBlinkingCat6, Images.challengeBlinkingCat7]
    static let challengeCrownsButton: UIImage? = UIImage(named: "challengeCrownsButton")
    static let challengeSudokuButton: UIImage? = UIImage(named: "challengeSudokuButton")
    static let challengeCompletedLevel: UIImage? = UIImage(named: "challengeCompletedLevel")
    static let challengeCalendar: UIImage? = UIImage(named: "challengeCalendar")
    
    // HomeView
    static let homeLogoPicture: UIImage? = UIImage(named: "homeLogoPicture")
    static let newGameButton: UIImage? = UIImage(named: "newGameButton")
    static let continueButton: UIImage? = UIImage(named: "continueButton")
    static let learningButton: UIImage? = UIImage(named: "learningButton")
    static let homeCalendar: UIImage? = UIImage(named: "homeCalendar")
    
    // GameSelector
    static let chooseCrownsButton: UIImage? = UIImage(named: "chooseCrownsButton")
    static let chooseSudokuButton: UIImage? = UIImage(named: "chooseSudokuButton")
    static let chooseQueensButton: UIImage? = UIImage(named: "chooseQueensButton")
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
    
    // ProfileView
    static let nameMaxLength: Int = 12
    
    // MainTabBar
    static let tabBarSelectedIndex: Int = 1
    
    // GameSellector
    static let gameSelectorOverlay: CGFloat = 0.3
    
    // BlinkingCat
    static let blinkingAnimationDuration: Double = 0.6
    static let blinkingRepeat: Int = 1
    
    // CustomNumberPicker
    static let numberPickerTintAlpha: Double = 0
    static let numberPickerComponentsNumber: Int = 1
    
    // CustomTimePicker
    static let timePickerStartPosition: String = "00"
    static let timePickerMin: Int = 0
    static let timePickerMax: Int = 59
    static let timePickerFormat: String = "%02d"
    static let timePickerTintAlpha: Double = 0
    static let timePickerComponentsNumber: Int = 2
    
    // GameSettingsView
    static let levelEasyTag: Int = 0
    static let levelMediumTag: Int = 1
    static let levelHardTag: Int = 2
    static let levelRandomTag: Int = 3
    static let queensSizeMin: Int = 4
    static let queensSizeMax: Int = 12
    
}

enum Text {
    // Common
    static let initErrorCoder: String = "init(coder:) has not been implemented"
    static let initErrorFrame: String = "init(frame:) has not been implemented"
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
    
    // ProfileView
    static let profileLogo: String = "Profile"
    static let changeAvatarButtonText: String = "Choose photo"
    static let userNamePlaceholder: String = "User name"
    
    // GameSellector
    static let chooseGame: String = "Choose game:"
    static let chooseLearning: String = "Choose learning:"
    
    // ChallengeView
    static let challengeLogo: String = "The daily challenge\nCAT AND MOUSE"
    static let streak: String = "Current streak: 0"
    
    // GameSettingsView
    static let chooseDifficulty: String = "Choose the difficulty level:"
    static let chooseFieldsSize: String = "Set the field size:"
    static let timerLabel: String = "Timer"
}

enum Constraints {
    // Common
    static let textSize: CGFloat = 17
    
    // HomeView
    static let homeLogoPictureTop: CGFloat = 0
    static let homeLogoTextTop: CGFloat = 5
    static let homeLogoTextWidth: CGFloat = 350
    static let homeLogoSize: CGFloat = 75
    static let homeCalendarTop: CGFloat = 45
    static let homeCalendarWidth: CGFloat = 350
    static let homeCalendarHeight: CGFloat = 250
    static let newGameButtonTop: CGFloat = 45
    static let continueButtonTop: CGFloat = 15
    static let learningButtonTop: CGFloat = 15
    static let tabBarItemIndentation: CGFloat = 10
    
    // GameSellector
    static let gameSelectorRadius: CGFloat = 16
    static let gameSelectorHeight: CGFloat = 310
    static let chooseCrownsButtonTop: CGFloat = 30
    static let chooseSudokuButtonTop: CGFloat = 15
    static let chooseQueensButtonTop: CGFloat = 15
    static let chooseTextTop: CGFloat = 30
    static let selectorTextSize: CGFloat = 25
    
    // ProfileView
    static let profileLogoSize: CGFloat = 35
    static let profileLogoTextTop: CGFloat = 5
    static let avatarImageFieldTop: CGFloat = 20
    static let imageViewSize: CGFloat = 100
    static let imageViewRadius: CGFloat = 50
    static let nameTextFieldTop: CGFloat = 10
    static let nameTextFieldWidth: CGFloat = 200
    static let changeAvatarButtonTop: CGFloat = 10
    static let changeAvatarButtonTextSize: CGFloat = 16
    static let profileButtonStackSpacing: CGFloat = 15
    static let profileButtonStackTop: CGFloat = 100
    
    // ChallengeView
    static let challengeLogoTextTop: CGFloat = 5
    static let challengeLogoSize: CGFloat = 35
    static let lightning1Top: CGFloat = -100
    static let lightning2Top: CGFloat = -110
    static let lightning1Left: CGFloat = -50
    static let lightning2Right: CGFloat = -20
    static let lightningAnimation1Top: CGFloat = -70
    static let lightningAnimation2Top: CGFloat = -80
    static let lightningAnimation1Left: CGFloat = 210
    static let lightningAnimation2Right: CGFloat = 210
    static let challengeCatTop: CGFloat = 130
    static let challengeCatLeft: CGFloat = 10
    static let challengeMiceTop: CGFloat = 160
    static let challengeMiceRight: CGFloat = 20
    static let challengeCalendarTop: CGFloat = 75
    static let challengeCrownsButtonTop: CGFloat = 45
    static let challengeSudokuButtonTop: CGFloat = 15
    static let challengeCalendarWidth: CGFloat = 350
    static let challengeCalendarHeight: CGFloat = 200
    static let streakTextSize: CGFloat = 17
    
    // GameSettingsView
    static let gameLogoSize: CGFloat = 34
    static let startPlayButtonBottom: CGFloat = 30
    static let gameLogoTop: CGFloat = 0
    static let settingsTextSize: CGFloat = 24
    static let choosingDifficultyTextTop: CGFloat = 25
    static let settingsButtonStackTop: CGFloat = 30
    static let settingsButtonStackSpacing: CGFloat = 10
    static let numberFieldRadius: CGFloat = 10
    static let timerStackSpacing: CGFloat = 20
    static let timerPickerWidth: CGFloat = 90
    static let timerStackTop: CGFloat = 30
    static let timerPickerTop: CGFloat = 30
    static let numberFieldWidth: CGFloat = 30
    static let numberFieldLeft: CGFloat = 15
}


