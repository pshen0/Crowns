//
//  File.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation
import UIKit

protocol ProfileBusinessLogic {
    func settingsButtonTapped(_ request: ProfileModel.RouteSettings.Request)
    func statisticsButtonTapped(_ request: ProfileModel.RouteStatistics.Request)
    func developerButtonTapped(_ request: ProfileModel.RouteDeveloper.Request)
    func loadProfileData(_ request: ProfileModel.LoadProfile.Request)
    func saveProfileData(_ request: ProfileModel.SaveProfile.Request)
}

final class ProfileInteractor: ProfileBusinessLogic {
    
    private let presenter: ProfilePresentationLogic
    
    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }
    
    func settingsButtonTapped(_ request: ProfileModel.RouteSettings.Request) {
        presenter.routeSettings(ProfileModel.RouteSettings.Response())
    }
    
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
