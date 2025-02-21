//
//  CrownsPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol CrownsPlayBusinessLogic {
    func backButtonTapped(_ request: CrownsPlayModel.RouteBack.Request)
}

final class CrownsPlayInteractor: CrownsPlayBusinessLogic {
    
    private let presenter: CrownsPlayPresentationLogic
    
    init(presenter: CrownsPlayPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: CrownsPlayModel.RouteBack.Request) {
        presenter.roureBack(CrownsPlayModel.RouteBack.Response())
    }
}
