//
//  CoreDataManager.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(CoreData.loadError)
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
