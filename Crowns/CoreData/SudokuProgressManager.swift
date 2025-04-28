//
//  SudokuProgressManager.swift
//  Crowns
//
//  Created by Анна Сазонова on 14.04.2025.
//

import CoreData

final class CoreDataSudokuProgressStack {
    static let shared = CoreDataSudokuProgressStack()
    let context = CoreDataStack.shared.context
    
    func saveProgress(
        isTimerUsed: Bool,
        initialTime: Int32,
        elapsedTime: Int32,
        killerSudoku: KillerSudoku
    ) {
        let request: NSFetchRequest<NSFetchRequestResult> = SudokuProgress.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
        
        let progress = SudokuProgress(context: context)
        progress.isTimerUsed = isTimerUsed
        progress.initialTime = initialTime
        progress.elapsedTime = elapsedTime
        
        if let killerSudokuData = try? JSONEncoder().encode(killerSudoku) {
            progress.sudoku = killerSudokuData
        }
        
        do {
            try context.save()
        } catch {
            print(CoreData.saveError)
        }
    }
    
    func fetchProgress() -> SudokuPlayModel.BuildModule.BuildFoundation? {
        let request = SudokuProgress.fetchRequest()
        request.fetchLimit = Constants.requestLimit
        
        if let result = try? context.fetch(request).first,
           let killerSudokuData = result.sudoku,
           let killerSudoku = try? JSONDecoder().decode(KillerSudoku.self, from: killerSudokuData) {
            
            return SudokuPlayModel.BuildModule.BuildFoundation(
                killerSudoku: killerSudoku,
                elapsedTime: Int(result.elapsedTime),
                initialTime: Int(result.initialTime),
                isTimerUsed: result.isTimerUsed)

        }
        return nil
    }
    
    func deleteAllProgress() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SudokuProgress.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(CoreData.deleteError)
        }
    }
    
    private enum Constants {
        static let requestLimit = 1
    }
}
