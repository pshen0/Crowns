//
//  ProfileDataManager.swift
//  Crowns
//
//  Created by Анна Сазонова on 14.04.2025.
//

import UIKit
import CoreData

final class CoreDataProfileStack {
    static let shared = CoreDataProfileStack()
    let context = CoreDataStack.shared.context
    
    func saveContext(name: String?, avatar: UIImage?) {
        let profile = fetchProfile() ?? ProfileData(context: context)
        profile.userName = name
        if let avatar = avatar {
            profile.userAvatar = avatar.jpegData(compressionQuality: Constants.jpegQuality)
        }
        try? context.save()
    }
    
    func fetchProfile() -> ProfileData? {
        let request: NSFetchRequest<ProfileData> = ProfileData.fetchRequest()
        return try? context.fetch(request).first
    }
    
    private enum Constants {
        static let jpegQuality = 0.9
    }
}
