import CoreData

final class CoreDataSudokuStatisticStack {
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
    
    func getStatistics() -> [StatisticsModel.StatisticItem] {
        let stats = statistics
        return [
            .init(title: "Games started", value: "\(stats.totalStarted)"),
            .init(title: "Games won", value: "\(stats.totalWins)"),
            .init(title: "Games won: easy", value: "\(stats.easyWins)"),
            .init(title: "Games won: medium", value: "\(stats.mediumWins)"),
            .init(title: "Games won: hard", value: "\(stats.hardWins)"),
            .init(title: "Win rate", value: "\(stats.winRate)%"),
            .init(title: "The best time", value: stats.bestTime > 0 ? formatTime(time: stats.bestTime) : "-"),
            .init(title: "The average time", value: stats.averageTime > 0 ? formatTime(time: stats.averageTime) : "-")
        ]
    }
    
    func recordGameStarted() {
        statistics.totalStarted += 1
        updateWinRate()
        save()
    }
    
    func recordWin(difficulty: String, time: Int32?) {
        statistics.totalWins += 1
        
        switch difficulty {
        case "Easy": statistics.easyWins += 1
        case "Medium": statistics.mediumWins += 1
        case "Hard": statistics.hardWins += 1
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
    
    private func updateWinRate() {
        if statistics.totalStarted > 0 {
            statistics.winRate = (statistics.totalWins * 100) / statistics.totalStarted
        } else {
            statistics.winRate = 0
        }
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save statistics: \(error)")
        }
    }
    
    private func formatTime(time: Int32) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
