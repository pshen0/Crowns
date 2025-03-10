//
//  SudokuPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol SudokuPlayBusinessLogic {
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request)
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeNumberCell.Request) -> SudokuPlayModel.ChangeNumberCell.ViewModel
}

final class SudokuPlayInteractor: SudokuPlayBusinessLogic {
    
    private let presenter: SudokuPlayPresentationLogic
    
    init(presenter: SudokuPlayPresentationLogic) {
        self.presenter = presenter
    }
    
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request) {
        presenter.routeBack(SudokuPlayModel.RouteBack.Response())
    }
    
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeNumberCell.Request) -> SudokuPlayModel.ChangeNumberCell.ViewModel {
        let indexes = presenter.changeNumberCell(SudokuPlayModel.ChangeNumberCell.Response(index: request.index))
        return indexes
    }
}
