//
//  CrownsPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol CrownsPlayPresentationLogic {
    func roureBack(_ response: CrownsPlayModel.RouteBack.Response)
}

final class CrownsPlayPresenter: CrownsPlayPresentationLogic {
    
    weak var view: CrownsPlayViewController?
    
    func roureBack(_ response: CrownsPlayModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
