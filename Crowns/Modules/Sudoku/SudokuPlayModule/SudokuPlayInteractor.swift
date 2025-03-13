//
//  SudokuPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

protocol SudokuPlayBusinessLogic {
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request)
    func cellChanged(_ request: SudokuPlayModel.ChangeCell.Request) -> SudokuPlayModel.ChangeCell.ViewModel
    func playFinished(_ request: SudokuPlayModel.RouteGameOver.Request)
}

final class SudokuPlayInteractor: SudokuPlayBusinessLogic {
    
    private let presenter: SudokuPlayPresentationLogic
    private let killerSudoku: KillerSudoku
    
    init(presenter: SudokuPlayPresentationLogic, killerSudoku: KillerSudoku) {
        self.presenter = presenter
        self.killerSudoku = killerSudoku
    }
    
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request) {
        presenter.routeBack(SudokuPlayModel.RouteBack.Response())
    }
    
    func cellChanged(_ request: SudokuPlayModel.ChangeCell.Request) -> SudokuPlayModel.ChangeCell.ViewModel {
        let indexes = presenter.getCellPosition(SudokuPlayModel.ChangeCell.Response(index: request.index))
        return indexes
    }
    
    func playFinished(_ request: SudokuPlayModel.RouteGameOver.Request) {
        presenter.routeGameOver(SudokuPlayModel.RouteGameOver.Response(isWin: request.isWin))
    }
}
