//
//  CoreDataManager.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import CoreData

// MARK: - CoreDataStack Class
final class CoreDataStack {
    // MARK: - Properties
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreData.containerName)
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
