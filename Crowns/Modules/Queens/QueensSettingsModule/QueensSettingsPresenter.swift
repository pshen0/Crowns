////
////  QueensSettingsPresenter.swift
////  Crowns
////
////  Created by Анна Сазонова on 20.02.2025.
////
//
//import Foundation
//
//protocol QueensSettingsPresentationLogic {
//    func routeQueensGame(_ response: QueensSettingsModel.RouteQueensGame.Response)
//    func routeBack(_ response: QueensSettingsModel.RouteBack.Response)
//}
//
//final class QueensSettingsPresenter: QueensSettingsPresentationLogic {
//    
//    weak var view: QueensSettingsViewController?
//    
//    func routeQueensGame(_ response: QueensSettingsModel.RouteQueensGame.Response) {
//        view?.navigationController?.pushViewController(QueensPlayBuilder.build(), animated: false)
//    }
//    
//    func routeBack(_ response: QueensSettingsModel.RouteBack.Response) {
//        view?.navigationController?.popViewController(animated: false)
//    }
//}
