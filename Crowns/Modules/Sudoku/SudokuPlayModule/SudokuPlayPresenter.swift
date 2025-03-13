//
//  SudokuPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SudokuPlayPresentationLogic {
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response)
    func routeGameOver(_ response: SudokuPlayModel.RouteGameOver.Response)
    func getCellPosition(_ response: SudokuPlayModel.ChangeCell.Response) -> SudokuPlayModel.ChangeCell.ViewModel
}

final class SudokuPlayPresenter: SudokuPlayPresentationLogic {
    
    weak var view: SudokuPlayViewController?
    
    func routeBack(_ response: SudokuPlayModel.RouteBack.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeGameOver(_ response: SudokuPlayModel.RouteGameOver.Response) {
        let gameOverViewController = SudokuGameOverBuilder.build()
        gameOverViewController.isWin = response.isWin
        view?.navigationController?.pushViewController(gameOverViewController, animated: false)
    }
    
    private func getTablePosition(_ index: Int) -> (Int, Int) {
        var position = index
        var row = (position / 27) * 3
        position = position % 27
        var col = (position / 9) * 3
        position = position % 9
        row += position / 3
        col += position % 3
        return (row, col)
    }
    
    func getCellPosition(_ response: SudokuPlayModel.ChangeCell.Response) -> SudokuPlayModel.ChangeCell.ViewModel {
        var arrayRow: Int = 0
        var arrayCol: Int = 0
        (arrayRow, arrayCol) = getTablePosition(response.index)
        
        let blockIndex = response.index / 9
        let cellIndex = response.index % 9
        let blockIndexPath = IndexPath(item: blockIndex, section: 0)
        
        let indexes: SudokuPlayModel.ChangeCell.ViewModel = SudokuPlayModel.ChangeCell.ViewModel(
            arrayRow: arrayRow,
            arrayCol: arrayCol,
            blockIndexPath: blockIndexPath,
            blockIndex: blockIndex,
            cellIndex: cellIndex
        )
        
        return indexes
    }
}
