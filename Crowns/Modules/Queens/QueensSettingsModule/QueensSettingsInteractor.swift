////
////  QueensSettingsInteractor.swift
////  Crowns
////
////  Created by Анна Сазонова on 20.02.2025.
////
//
//import Foundation
//
//protocol QueensSettingsBusinessLogic {
//    func startButtonTapped(_ request: QueensSettingsModel.RouteBack.Request)
//    func backButtonTapped(_ request: QueensSettingsModel.RouteBack.Request)
//}
//
//final class QueensSettingsInteractor: QueensSettingsBusinessLogic {
//    
//    private let presenter: QueensSettingsPresentationLogic
//    
//    init(presenter: QueensSettingsPresentationLogic) {
//        self.presenter = presenter
//    }
//    
//    func startButtonTapped(_ request: QueensSettingsModel.RouteBack.Request) {
//        presenter.routeQueensGame(QueensSettingsModel.RouteQueensGame.Response())
//    }
//    
//    func backButtonTapped(_ request: QueensSettingsModel.RouteBack.Request) {
//        presenter.routeBack(QueensSettingsModel.RouteBack.Response())
//    }
//}
