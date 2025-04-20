//
//  ProfilePresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation

protocol ProfilePresentationLogic {
    func routeSettings(_ response: ProfileModel.RouteSettings.Response)
    func routeStatistics(_ response: ProfileModel.RouteStatistics.Response)
    func routeDeveloper(_ response: ProfileModel.RouteDeveloper.Response)
    func transferProfileData(_ viewModel: ProfileModel.LoadProfile.Response)
}

final class ProfilePresenter: ProfilePresentationLogic {
    
    weak var view: ProfileViewController?
    
    func routeSettings(_ response: ProfileModel.RouteSettings.Response) {
        view?.navigationController?.pushViewController(SettingsBuilder.build(), animated: false)
    }
    
    func routeStatistics(_ response: ProfileModel.RouteStatistics.Response) {
        view?.navigationController?.pushViewController(StatisticsBuilder.build(), animated: false)
    }
    
    func routeDeveloper(_ response: ProfileModel.RouteDeveloper.Response) {
        view?.navigationController?.pushViewController(DeveloperBuilder.build(), animated: false)
    }
    
    func transferProfileData(_ response: ProfileModel.LoadProfile.Response) {
        view?.loadProfile(ProfileModel.LoadProfile.ViewModel(name: response.name, avatar: response.avatar))
    }
}
