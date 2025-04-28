//
//  CalendarDataManager.swift
//  Crowns
//
//  Created by Анна Сазонова on 27.04.2025.
//

import Foundation
import CoreData

final class CoreDataDatesStack {
    static let shared = CoreDataDatesStack()
    private let context = CoreDataStack.shared.context
    
    private init() {}

    func saveDate(_ date: Date) {
        let markedDate = CalendarData(context: context)
        markedDate.date = date
        try? context.save()
    }

    func fetchAllDates() -> [Date] {
        let request: NSFetchRequest<CalendarData> = CalendarData.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.date }
        } catch {
            return []
        }
    }
}
