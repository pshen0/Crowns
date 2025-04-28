//
//  CrownsSettingsPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 20.02.2025.
//

import Foundation

protocol CrownsSettingsPresentationLogic {
    func routeCrownsGame(_ response: CrownsSettingsModel.RouteCrownsGame.Response)
    func routeBack(_ response: CrownsSettingsModel.RouteBack.Response)
}

final class CrownsSettingsPresenter: CrownsSettingsPresentationLogic {
    
    weak var view: CrownsSettingsViewController?
    
    func routeCrownsGame(_ response: CrownsSettingsModel.RouteCrownsGame.Response) {
        var time: Int = 0
        if let minutes = Int(response.timerLabel.prefix(Constants.timePrefix)) {
            if let seconds = Int(response.timerLabel.suffix(Constants.timeSufix)) {
                time = minutes * 60 + seconds
            }
        }
        
        view?.navigationController?.pushViewController(CrownsPlayBuilder.build(CrownsPlayModel.BuildModule.BuildFoundation(
            crowns: Crowns(response.difficultyLevel),
            elapsedTime: Constants.elapsedTime,
            initialTime: time,
            isTimerUsed: time == 0 ? false : true,
            placements: Array(repeating: Array(repeating: 0, count: Constants.size), count: Constants.size))),
                                                       animated: false)
    }
    
    func routeBack(_ response: CrownsSettingsModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
    
    private enum Constants {
        static let size = 9
        static let elapsedTime = 0
        static let timePrefix = 2
        static let timeSufix = 2
    }
}
