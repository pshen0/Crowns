//
//  CrownsProgressManager.swift
//  Crowns
//
//  Created by Анна Сазонова on 14.04.2025.
//

import CoreData

final class CoreDataCrownsProgressStack {
    static let shared = CoreDataCrownsProgressStack()
    let context = CoreDataStack.shared.context
    
    func saveProgress(
        isTimerUsed: Bool,
        initialTime: Int32,
        elapsedTime: Int32,
        crowns: Crowns,
        placements: [[Int]]
    ) {
        let request: NSFetchRequest<NSFetchRequestResult> = CrownsProgress.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? context.execute(deleteRequest)
        
        let progress = CrownsProgress(context: context)
        progress.isTimerUsed = isTimerUsed
        progress.initialTime = initialTime
        progress.elapsedTime = elapsedTime
        
        if let crownsData = try? JSONEncoder().encode(crowns),
           let placementsData = try? JSONEncoder().encode(placements) {
            progress.crowns = crownsData
            progress.placements = placementsData
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save progress: \(error)")
        }
    }
    
    func fetchProgress() -> CrownsPlayModel.BuildModule.BuildFoundation? {
        let request = CrownsProgress.fetchRequest()
        request.fetchLimit = 1
        
        if let result = try? context.fetch(request).first,
           let crownsData = result.crowns,
           let placementsData = result.placements,
           let crowns = try? JSONDecoder().decode(Crowns.self, from: crownsData),
           let placements = try? JSONDecoder().decode([[Int]].self, from: placementsData) {
            
            return CrownsPlayModel.BuildModule.BuildFoundation(
                crowns: crowns,
                elapsedTime: Int(result.elapsedTime),
                initialTime: Int(result.initialTime),
                isTimerUsed: result.isTimerUsed,
                placements: placements)

        }
        return nil
    }
    
    func deleteAllProgress() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CrownsProgress.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete CrownsProgress entries: \(error)")
        }
    }
}
