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
        var time: CrownsPlayModel.Time = CrownsPlayModel.Time(minutes: 0, seconds: 0)
        if let minutes = Int(response.timerLabel.prefix(2)) {
            if let seconds = Int(response.timerLabel.suffix(2)) {
                time = CrownsPlayModel.Time(minutes: minutes, seconds: seconds)
            }
        } else {
            time = CrownsPlayModel.Time(minutes: 0, seconds: 0)
        }
        
        view?.navigationController?.pushViewController(CrownsPlayBuilder.build(CrownsPlayModel.BuildModule.BuildFoundation(difficultyLevel: response.difficultyLevel, time: time)), animated: false)
    }
    
    func routeBack(_ response: CrownsSettingsModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
