//
//  SudokuPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol SudokuPlayPresentationLogic {
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response)
}

final class SudokuPlayPresenter: SudokuPlayPresentationLogic {
    
    weak var view: SudokuPlayViewController?
    
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
