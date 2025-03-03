//
//  File.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation

protocol ProfileBusinessLogic {
    func settingsButtonTapped(_ request: ProfileModel.RouteSettings.Request)
    func statisticsButtonTapped(_ request: ProfileModel.RouteStatistics.Request)
    func developerButtonTapped(_ request: ProfileModel.RouteDeveloper.Request)
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
}
