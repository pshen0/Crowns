//
//  ChallengeInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation
import UIKit

protocol ChallengeBusinessLogic {
    func crownsButtonTapped(_ request: ChallengeModel.RouteCrownsGame.Request)
    func sudokuButtonTapped(_ request: ChallengeModel.RouteSudokuGame.Request)
    func setupDailyResetObserver(_ request: ChallengeModel.ResetChallenges.Request)
    func updateButtons(_ request: ChallengeModel.ResetChallenges.Request)
    func getStreak(_ request: ChallengeModel.GetStreak.Request)
}

final class ChallengeInteractor: ChallengeBusinessLogic {
    
    private let presenter: ChallengePresentationLogic
    
    init(presenter: ChallengePresentationLogic) {
        self.presenter = presenter
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func crownsButtonTapped(_ request: ChallengeModel.RouteCrownsGame.Request) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.crownsChallengeAvailable)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.crownsChallengeGoes)
        updateChallengeButtonsAvailability()
        presenter.routeCrownsGame(ChallengeModel.RouteCrownsGame.Response())
    }
    
    func sudokuButtonTapped(_ request: ChallengeModel.RouteSudokuGame.Request) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.sudokuChallengeAvailable)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.sudokuChallengeGoes)
        updateChallengeButtonsAvailability()
        presenter.routeSudokuGame(ChallengeModel.RouteSudokuGame.Response())
    }
    
    func setupDailyResetObserver(_ request: ChallengeModel.ResetChallenges.Request) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignificantTimeChange), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    func updateButtons(_ request: ChallengeModel.ResetChallenges.Request) {
        updateChallengeButtonsAvailability()
    }
    
    @objc private func handleSignificantTimeChange() {
        resetDailyChallengesIfNeeded()
        updateChallengeButtonsAvailability()
    }
    
    private func resetDailyChallengesIfNeeded() {
        let calendar = Calendar.current
        let now = Date()
        
        if let lastReset = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastResetDate) as? Date {
            if !calendar.isDate(lastReset, inSameDayAs: now) {
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.crownsChallengeAvailable)
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.sudokuChallengeAvailable)
                UserDefaults.standard.set(false, forKey: UserDefaultsKeys.crownsChallengeDone)
                UserDefaults.standard.set(false, forKey: UserDefaultsKeys.sudokuChallengeDone)
                UserDefaults.standard.set(now, forKey: UserDefaultsKeys.lastResetDate)
            }
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.crownsChallengeAvailable)
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.sudokuChallengeAvailable)
            UserDefaults.standard.set(now, forKey: UserDefaultsKeys.lastResetDate)
        }
    }
    
    private func updateChallengeButtonsAvailability() {
        
        if UserDefaults.standard.object(forKey: UserDefaultsKeys.crownsChallengeAvailable) == nil ||
            UserDefaults.standard.object(forKey: UserDefaultsKeys.sudokuChallengeAvailable) == nil {
            
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.crownsChallengeAvailable)
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.sudokuChallengeAvailable)
            UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastResetDate)
        }
        
        let isCrownsAvailable = UserDefaults.standard.bool(forKey: UserDefaultsKeys.crownsChallengeAvailable)
        let isSudokuAvailable = UserDefaults.standard.bool(forKey: UserDefaultsKeys.sudokuChallengeAvailable)
        
        presenter.changeButtonsAccessibility(ChallengeModel.ResetChallenges.Response(
            crownsAccessibility: isCrownsAvailable,
            sudokusAccessibility: isSudokuAvailable))
    }
    
    func getStreak(_ request: ChallengeModel.GetStreak.Request) {
        var markedDates = CoreDataDatesStack.shared.fetchAllDates()
        
        guard !markedDates.isEmpty else {
            presenter.presentStreakLabel(ChallengeModel.GetStreak.Response(daysNumber: 0))
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let markedSet = Set(markedDates.map { calendar.startOfDay(for: $0) })
        
        var streak = 0
        var currentDate = today

        if !markedSet.contains(today) {
            currentDate = calendar.date(byAdding: .day, value: -1, to: today)!
        }

        while markedSet.contains(currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        presenter.presentStreakLabel(ChallengeModel.GetStreak.Response(daysNumber: streak))
    }

}
