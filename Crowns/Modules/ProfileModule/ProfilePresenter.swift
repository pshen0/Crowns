//
//  ProfilePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation

// MARK: - ProfilePresentationLogic protocol
protocol ProfilePresentationLogic {
    func routeStatistics(_ response: ProfileModel.RouteStatistics.Response)
    func routeDeveloper(_ response: ProfileModel.RouteDeveloper.Response)
    func transferProfileData(_ viewModel: ProfileModel.LoadProfile.Response)
}

// MARK: - ProfilePresenter class
final class ProfilePresenter: ProfilePresentationLogic {
    
    // MARK: - Properties
    weak var view: ProfileViewController?
    
    // MARK: - Funcs
    func routeStatistics(_ response: ProfileModel.RouteStatistics.Response) {
        view?.navigationController?.pushViewController(StatisticsBuilder.build(game: StatisticsModel.GameType.crowns), animated: false)
    }
    
    func routeDeveloper(_ response: ProfileModel.RouteDeveloper.Response) {
        view?.navigationController?.pushViewController(DeveloperBuilder.build(), animated: false)
    }
    
    func transferProfileData(_ response: ProfileModel.LoadProfile.Response) {
        view?.loadProfile(ProfileModel.LoadProfile.ViewModel(name: response.name, avatar: response.avatar))
    }
}
