//
//  SudokuLearningPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import Foundation

protocol SudokuLearningPresentationLogic {
    func routeBack(_ response: SudokuLearningModel.RouteBack.Response)
}

final class SudokuLearningPresenter: SudokuLearningPresentationLogic {
    
    weak var view: SudokuLearningViewController?
    
    func routeBack(_ response: SudokuLearningModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
