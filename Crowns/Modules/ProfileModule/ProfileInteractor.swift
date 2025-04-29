//
//  File.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation
import UIKit

// MARK: - ProfileBusinessLogic protocol
protocol ProfileBusinessLogic {
    func statisticsButtonTapped(_ request: ProfileModel.RouteStatistics.Request)
    func developerButtonTapped(_ request: ProfileModel.RouteDeveloper.Request)
    func loadProfileData(_ request: ProfileModel.LoadProfile.Request)
    func saveProfileData(_ request: ProfileModel.SaveProfile.Request)
}

// MARK: - ProfileInteractor class
final class ProfileInteractor: ProfileBusinessLogic {
    
    // MARK: - Properties
    private let presenter: ProfilePresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Funcs
    func statisticsButtonTapped(_ request: ProfileModel.RouteStatistics.Request) {
        presenter.routeStatistics(ProfileModel.RouteStatistics.Response())
    }
    
    func developerButtonTapped(_ request: ProfileModel.RouteDeveloper.Request) {
        presenter.routeDeveloper(ProfileModel.RouteDeveloper.Response())
    }
    
    func loadProfileData(_ request: ProfileModel.LoadProfile.Request) {
        var name = ""
        var avatar = UIImage.startAvatar
        if let profile = CoreDataProfileStack.shared.fetchProfile() {
            if let nameData = profile.userName {
                name = nameData
            }
            if let avatarData = profile.userAvatar, let image = UIImage(data: avatarData) {
                avatar = image
            }
        }
        
        presenter.transferProfileData(ProfileModel.LoadProfile.Response(name: name, avatar: avatar))
    }
    
    func saveProfileData(_ request: ProfileModel.SaveProfile.Request) {
        CoreDataProfileStack.shared.saveContext(name: request.name, avatar: request.avatar)
    }
}
