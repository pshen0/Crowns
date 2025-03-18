//
//  SudokuPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SudokuPlayBusinessLogic {
    func getCages(_ request: SudokuPlayModel.GetCages.Request) -> [SudokuCage]
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeCellNumber.Request) -> [SudokuPlayModel.ChangeCellNumber.ViewModel]
    func cleanButtonTapped(_ request: SudokuPlayModel.DeleteCellNumber.Request) -> [SudokuPlayModel.DeleteCellNumber.ViewModel]
    func determineCellsWithSum(_ request: SudokuPlayModel.DetermineCellsWithSum.Request) -> SudokuPlayModel.DetermineCellsWithSum.ViewModel
    func isPlayFinished(_ request: SudokuPlayModel.CheckGameOver.Request)
    func pauseButtonTapped(_ request: SudokuPlayModel.PauseGame.Request)
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request)
}

final class SudokuPlayInteractor: SudokuPlayBusinessLogic {
    
    private let presenter: SudokuPlayPresentationLogic
    private let killerSudoku: KillerSudoku
    private var time: SudokuPlayModel.Time
    private var timer: Timer? = Timer()
    private var timeGoes: Bool = true
    
    init(presenter: SudokuPlayPresentationLogic, killerSudoku: KillerSudoku, time: SudokuPlayModel.Time) {
        self.presenter = presenter
        self.killerSudoku = killerSudoku
        self.time = time
        startTimer()
    }
    
    private func startTimer() {
        if time.minutes != 0 || time.seconds != 0 {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func changeTime() {
        if time.seconds > 0 {
            time.seconds -= 1
            presenter.presentTime(SudokuPlayModel.SetTime.Response(time: time))
        } else if time.minutes > 0 {
            time.minutes -= 1
            time.seconds = 59
            presenter.presentTime(SudokuPlayModel.SetTime.Response(time: time))
        } else {
            playFinished(isWin: false)
        }
    }
    
    private func isChangeCorrect(row: Int, col: Int, number: Int) -> String {
        if number == 0 {
            return Text.correctMode
        }
        for i in 0..<9 {
            if i != col &&  i != row {
                if killerSudoku.getPuzzle()[row][i] == number ||  killerSudoku.getPuzzle()[i][col] == number {
                    return Text.incorrectMode
                }
            }
        }
        
        for i in (row / 3 * 3)...(row / 3 * 3 + 2) {
            for j in (col / 3 * 3)...(col / 3 * 3 + 2) {
                if i != col &&  i != row {
                    if killerSudoku.getPuzzle()[i][j] == number {
                        return Text.incorrectMode
                    }
                }
            }
        }
        
        if let targetCage = killerSudoku.getCages().first(where: { cage in
            cage.getCells().contains { $0.row == row && $0.col == col }
        }) {
            var sum = 0
            var filledCells = 0
            for cell in targetCage.getCells() {
                if killerSudoku.puzzle[cell.row][cell.col] != 0 {
                    sum += killerSudoku.puzzle[cell.row][cell.col]
                    filledCells += 1
                }
                if sum > targetCage.getSum() {
                    return Text.incorrectMode
                }
                if filledCells == targetCage.getCells().count && sum != targetCage.getSum() {
                    return Text.incorrectMode
                }
            }
        }
        return Text.correctMode
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

    
    func getCages(_ request: SudokuPlayModel.GetCages.Request) -> [SudokuCage] {
        let cages = killerSudoku.getCages()
        return cages
    }
    
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request) {
        timer?.invalidate()
        timer = nil
        presenter.routeBack(SudokuPlayModel.RouteBack.Response())
    }
    
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeCellNumber.Request) -> [SudokuPlayModel.ChangeCellNumber.ViewModel] {
        var changedCells = [SudokuPlayModel.ChangeCellNumber.ViewModel]()
        let (row, col) = getTablePosition(request.index)
        
        if killerSudoku.unsolvedPuzzle[row][col] == 0 {
            killerSudoku.puzzle[row][col] = request.number
            for i in 0...8 {
                for j in 0...8 {
                    let blockIndex = (i / 3) * 3 + (j / 3)
                    let cellIndex = (i % 3) * 3 + (j % 3)
                    if killerSudoku.unsolvedPuzzle[i][j] == 0 {
                        let mode: String = isChangeCorrect(row: i, col: j, number: killerSudoku.puzzle[i][j])
                        let blockIndexPath = IndexPath(item: blockIndex, section: 0)
                        let cellIndexPath = IndexPath(item: cellIndex, section: 0)
                        let changedCell = SudokuPlayModel.ChangeCellNumber.ViewModel(blockIndex: blockIndexPath, cellIndex: cellIndexPath, number: killerSudoku.puzzle[i][j], mode: mode)
                        changedCells.append(changedCell)
                    }
                }
            }
        }
        return changedCells
    }
    
    func cleanButtonTapped(_ request: SudokuPlayModel.DeleteCellNumber.Request) -> [SudokuPlayModel.DeleteCellNumber.ViewModel] {
        var changedCells = [SudokuPlayModel.DeleteCellNumber.ViewModel]()
        let (row, col) = getTablePosition(request.index)
        
        if killerSudoku.unsolvedPuzzle[row][col] == 0 {
            killerSudoku.puzzle[row][col] = 0
            var blockIndex = (row / 3) * 3 + (col / 3)
            var cellIndex = (row % 3) * 3 + (col % 3)
            var blockIndexPath = IndexPath(item: blockIndex, section: 0)
            var cellIndexPath = IndexPath(item: cellIndex, section: 0)
            var changedCell = SudokuPlayModel.DeleteCellNumber.ViewModel(blockIndex: blockIndexPath, cellIndex: cellIndexPath, number: 0, mode: "correct")
            changedCells.append(changedCell)
            for i in 0...8 {
                for j in 0...8 {
                    blockIndex = (i / 3) * 3 + (j / 3)
                    cellIndex = (i % 3) * 3 + (j % 3)
                    if killerSudoku.unsolvedPuzzle[i][j] == 0 {
                        let mode: String = isChangeCorrect(row: i, col: j, number: killerSudoku.puzzle[i][j])
                        blockIndexPath = IndexPath(item: blockIndex, section: 0)
                        cellIndexPath = IndexPath(item: cellIndex, section: 0)
                        changedCell = SudokuPlayModel.DeleteCellNumber.ViewModel(blockIndex: blockIndexPath, cellIndex: cellIndexPath, number: killerSudoku.puzzle[i][j], mode: mode)
                        changedCells.append(changedCell)
                    }
                }
            }
        }
        return changedCells
    }
    
    func isPlayFinished(_ request: SudokuPlayModel.CheckGameOver.Request) {
        if killerSudoku.getTable() == killerSudoku.puzzle {
            playFinished(isWin: true)
        }
    }
    
    func determineCellsWithSum(_ request: SudokuPlayModel.DetermineCellsWithSum.Request) -> SudokuPlayModel.DetermineCellsWithSum.ViewModel {
        let blockRow = request.index / 3
        let blockCol = request.index % 3
        var blockData = [Int]()
        var cellsWithSum = [(IndexPath, Int)]()
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                let row = blockRow * 3 + i
                let col = blockCol * 3 + j
                blockData.append(killerSudoku.puzzle[row][col])
            }
        }
        
        for cage in killerSudoku.getCages() {
            if let minCageCell = cage.getCells().min(by: {
                $0.row < $1.row || ($0.row == $1.row && $0.col < $1.col)
            }) {
                let blockIndex = (minCageCell.row / 3) * 3 + (minCageCell.col / 3)
                let cellIndex = (minCageCell.row % 3) * 3 + (minCageCell.col) % 3
                
                if blockIndex == request.index {
                    let cellIndexPath = IndexPath(item: cellIndex, section: 0)
                    cellsWithSum.append((cellIndexPath, cage.getSum()))
                }
            }
        }
        
        return SudokuPlayModel.DetermineCellsWithSum.ViewModel(cellsWithSum: cellsWithSum, blockData: blockData)
    }
    
    func pauseButtonTapped(_ request: SudokuPlayModel.PauseGame.Request) {
        if timeGoes {
            timeGoes = false
            timer?.invalidate()
            timer = nil
        } else {
            timeGoes = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeTime), userInfo: nil, repeats: true)
        }
    }
    
    private func playFinished(isWin: Bool) {
        timer?.invalidate()
        timer = nil
        presenter.routeGameOver(SudokuPlayModel.RouteGameOver.Response(isWin: isWin))
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
