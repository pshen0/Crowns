//
//  SudokuLearningPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

// MARK: - SudokuLearningPresentationLogic protocol
protocol SudokuLearningPresentationLogic {
    func routeBack(_ response: SudokuLearningModel.RouteBack.Response)
}

// MARK: - SudokuLearningPresenter class
final class SudokuLearningPresenter: SudokuLearningPresentationLogic {
    
    // MARK: - Properties
    weak var view: SudokuLearningViewController?
    
    // MARK: - Funcs
    func routeBack(_ response: SudokuLearningModel.RouteBack.Response) {
        view?.navigationController?.popViewController(animated: false)
    }
}
