import CoreData

// MARK: - CoreDataSudokuStatisticStack class
final class CoreDataSudokuStatisticStack {
    // MARK: - Properties
    static let shared = CoreDataSudokuStatisticStack()
    private let context = CoreDataStack.shared.context
    
    private var statistics: SudokuStatistic {
        if let existing = try? context.fetch(SudokuStatistic.fetchRequest()).first {
            return existing
        } else {
            let new = SudokuStatistic(context: context)
            new.totalStarted = 0
            new.totalWins = 0
            new.easyWins = 0
            new.mediumWins = 0
            new.hardWins = 0
            new.bestTime = 0
            new.averageTime = 0
            new.winRate = 0
            new.gamesWithTime = 0
            try? context.save()
            return new
        }
    }
    
    // MARK: - Funcs
    // Fetch data
    func getStatistics() -> [StatisticsModel.StatisticItem] {
        let stats = statistics
        return [
            .init(title: StatisticsFields.all, value: "\(stats.totalStarted)"),
            .init(title: StatisticsFields.allWin, value: "\(stats.totalWins)"),
            .init(title: StatisticsFields.easyWin, value: "\(stats.easyWins)"),
            .init(title: StatisticsFields.mediumWin, value: "\(stats.mediumWins)"),
            .init(title: StatisticsFields.hardWin, value: "\(stats.hardWins)"),
            .init(title: StatisticsFields.winRate, value: "\(stats.winRate)%"),
            .init(title: StatisticsFields.bestTime, value: stats.bestTime > 0 ? formatTime(time: stats.bestTime) : "-"),
            .init(title: StatisticsFields.averageTime, value: stats.averageTime > 0 ? formatTime(time: stats.averageTime) : "-")
        ]
    }
    
    // Record start
    func recordGameStarted() {
        statistics.totalStarted += 1
        updateWinRate()
        save()
    }
    
    // Record win
    func recordWin(difficulty: String, time: Int32?) {
        statistics.totalWins += 1
        
        switch difficulty {
        case DifficultyLevels.easy: statistics.easyWins += 1
        case DifficultyLevels.medium: statistics.mediumWins += 1
        case DifficultyLevels.hard: statistics.hardWins += 1
        default: break
        }
        
        if let time = time {
            if statistics.bestTime == 0 || time < statistics.bestTime {
                statistics.bestTime = time
            }
            
            statistics.gamesWithTime += 1
            let totalTime = statistics.averageTime * (statistics.gamesWithTime - 1) + time
            statistics.averageTime = totalTime / statistics.gamesWithTime
        }
        
        updateWinRate()
        save()
    }
    
    // MARK: - Private funcs
    // Update win
    private func updateWinRate() {
        if statistics.totalStarted > 0 {
            statistics.winRate = (statistics.totalWins * 100) / statistics.totalStarted
        } else {
            statistics.winRate = 0
        }
    }
    
    // Save data
    private func save() {
        do {
            try context.save()
        } catch {
            print(CoreData.saveError)
        }
    }
    
    // Format time as string
    private func formatTime(time: Int32) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: Constants.timeFormatter, minutes, seconds)
    }
    
    // MARK: - Constants
    private enum Constants {
        static let timeFormatter = "%02d:%02d"
    }
}
