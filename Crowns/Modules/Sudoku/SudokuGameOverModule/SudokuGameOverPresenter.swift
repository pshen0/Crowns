//
//  SudokuGameOverPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 11.03.2025.
//

import Foundation

protocol SudokuGameOverPresentationLogic {
    func routeHome(_ response: SudokuGameOverModel.RouteHome.Response)
}

final class SudokuGameOverPresenter: SudokuGameOverPresentationLogic {
    
    weak var view: SudokuGameOverViewController?
    
    func routeHome(_ response: SudokuGameOverModel.RouteHome.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
}
