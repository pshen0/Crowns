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
        view?.navigationController?.pushViewController(CrownsPlayBuilder.build(), animated: false)
    }
    
    func routeBack(_ response: CrownsSettingsModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
