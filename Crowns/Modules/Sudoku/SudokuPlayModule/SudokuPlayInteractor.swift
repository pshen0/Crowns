//
//  SudokuPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol SudokuPlayBusinessLogic {
    func getCages(_ request: SudokuPlayModel.GetCages.Request) -> [SudokuCage]
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeCellNumber.Request)
    func cleanButtonTapped(_ request: SudokuPlayModel.DeleteCellNumber.Request)
    func determineCellsWithSum(_ request: SudokuPlayModel.DetermineCellsWithSum.Request) -> SudokuPlayModel.DetermineCellsWithSum.ViewModel
    func isPlayFinished(_ request: SudokuPlayModel.CheckGameOver.Request) -> Bool
    func isPlayChallenge(_ request: SudokuPlayModel.CheckChallenge.Request) -> Bool
    func pauseButtonTapped(_ request: SudokuPlayModel.PauseGame.Request)
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request)
    func startTimer(_ request: SudokuPlayModel.StartTimer.Request)
    func timeIsUp() -> Bool
    func leaveGame(_ request: SudokuPlayModel.LeaveGame.Request)
    func gameIsWon(_ request: SudokuPlayModel.GameIsWon.Request)
    func hintButtonTapped(_ request: SudokuPlayModel.GetHint.Request)
    func undoButtonTapped(_ request: SudokuPlayModel.UndoMove.Request)
    func saveMove(_ request: SudokuPlayModel.SaveMove.Request)
    func getLevelPictute(_ request: SudokuPlayModel.GetLevel.Request)
}

final class SudokuPlayInteractor: SudokuPlayBusinessLogic {
    
    private let presenter: SudokuPlayPresentationLogic
    private let killerSudoku: KillerSudoku
    private var elapsedTime: Int
    private var initialTime: Int
    private var isTimerUsed: Bool
    private var timer: Timer? = Timer()
    private var timeGoes: Bool = true
    private var savedMoves: [SudokuPlayModel.SudokuMove] = []
    
    init(presenter: SudokuPlayPresentationLogic, foundation: SudokuPlayModel.BuildModule.BuildFoundation) {
        self.presenter = presenter
        self.killerSudoku = foundation.killerSudoku
        self.initialTime = foundation.initialTime
        self.elapsedTime = foundation.elapsedTime
        self.isTimerUsed = foundation.isTimerUsed
    }
    
    func startTimer(_ request: SudokuPlayModel.StartTimer.Request) {
        initTimer()
    }
    
    private func initTimer() {
        timeGoes = true
        if isTimerUsed {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reverseTimeChange), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(forwardTimeChange), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func reverseTimeChange() {
        if initialTime - elapsedTime > 0 {
            elapsedTime += 1
            presenter.presentTime(SudokuPlayModel.SetTime.Response(time: initialTime - elapsedTime))
        } else {
            playFinished(isWin: false)
        }
    }
    
    @objc private func forwardTimeChange() {
        elapsedTime += 1
        presenter.presentTime(SudokuPlayModel.SetTime.Response(time: elapsedTime))
    }
    
    func timeIsUp() -> Bool {
        return elapsedTime >= initialTime && isTimerUsed
    }
    
    private func isChangeCorrect(row: Int, col: Int, number: Int) -> String {
        if number == 0 {
            return SudokuCellMode.correct
        }
        for i in 0..<9 {
            if i != col &&  i != row {
                if killerSudoku.getPuzzle()[row][i] == number ||  killerSudoku.getPuzzle()[i][col] == number {
                    return SudokuCellMode.incorrect
                }
            }
        }
        
        for i in (row / 3 * 3)...(row / 3 * 3 + 2) {
            for j in (col / 3 * 3)...(col / 3 * 3 + 2) {
                if i != col &&  i != row {
                    if killerSudoku.getPuzzle()[i][j] == number {
                        return SudokuCellMode.incorrect
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
                    return SudokuCellMode.incorrect
                }
                if filledCells == targetCage.getCells().count && sum != targetCage.getSum() {
                    return SudokuCellMode.incorrect
                }
            }
        }
        return SudokuCellMode.correct
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
        deinitTimer()
        presenter.routeBack(SudokuPlayModel.RouteBack.Response())
    }
    
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeCellNumber.Request) {
        var changedCells = [SudokuPlayModel.ChangeCell.Change]()
        let (row, col) = getTablePosition(request.index)
        
        if killerSudoku.unsolvedPuzzle[row][col] == 0 {
            killerSudoku.puzzle[row][col] = request.number
            changedCells = findChanges()
        }
        
        presenter.setPlaygroundChanges(SudokuPlayModel.ChangeCell.Response(changes: changedCells))
    }
    
    func cleanButtonTapped(_ request: SudokuPlayModel.DeleteCellNumber.Request) {
        var changedCells = [SudokuPlayModel.ChangeCell.Change]()
        let (row, col) = getTablePosition(request.index)
        
        if killerSudoku.unsolvedPuzzle[row][col] == 0 {
            killerSudoku.puzzle[row][col] = 0
            let blockIndex = (row / 3) * 3 + (col / 3)
            let cellIndex = (row % 3) * 3 + (col % 3)
            let blockIndexPath = IndexPath(item: blockIndex, section: 0)
            let cellIndexPath = IndexPath(item: cellIndex, section: 0)
            let changedCell = SudokuPlayModel.ChangeCell.Change(blockIndex: blockIndexPath, cellIndex: cellIndexPath, number: 0, mode: SudokuCellMode.correct)
            changedCells.append(changedCell)
            
            changedCells = findChanges()
        }
        
        presenter.setPlaygroundChanges(SudokuPlayModel.ChangeCell.Response(changes: changedCells))
    }
    
    func undoButtonTapped(_ request: SudokuPlayModel.UndoMove.Request) {
        if !savedMoves.isEmpty {
            if let sudokuMove = savedMoves.last {
                let (row, col) = getTablePosition(sudokuMove.index)
                killerSudoku.puzzle[row][col] = sudokuMove.value
                let changedCells = findChanges()
                savedMoves.remove(at: savedMoves.count - 1)
                presenter.setPlaygroundChanges(SudokuPlayModel.ChangeCell.Response(changes: changedCells))
            }
        }
    }
    
    func determineCellsWithSum(_ request: SudokuPlayModel.DetermineCellsWithSum.Request) -> SudokuPlayModel.DetermineCellsWithSum.ViewModel {
        let blockRow = request.index / 3
        let blockCol = request.index % 3
        var blockData: [Int] = []
        var initData: [Int] = []
        var cellsWithSum = [(IndexPath, Int)]()
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                let row = blockRow * 3 + i
                let col = blockCol * 3 + j
                blockData.append(killerSudoku.puzzle[row][col])
                initData.append(killerSudoku.unsolvedPuzzle[row][col])
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
        
        return SudokuPlayModel.DetermineCellsWithSum.ViewModel(cellsWithSum: cellsWithSum, blockData: blockData, initData: initData)
    }
    
    func pauseButtonTapped(_ request: SudokuPlayModel.PauseGame.Request) {
        if timeGoes {
            deinitTimer()
        } else {
            initTimer()
        }
    }
    
    func hintButtonTapped(_ request: SudokuPlayModel.GetHint.Request) {
        var hintFounded = false
        for i in 0...8 {
            for j in 0...8 {
                if killerSudoku.puzzle[i][j] == 0 {
                    killerSudoku.puzzle[i][j] = killerSudoku.table[i][j]
                    hintFounded = true
                    break
                }
            }
            if hintFounded { break }
        }
        
        let changedCells = findChanges()
        presenter.setPlaygroundChanges(SudokuPlayModel.ChangeCell.Response(changes: changedCells))
    }
    
    private func findChanges() -> [SudokuPlayModel.ChangeCell.Change] {
        var changedCells = [SudokuPlayModel.ChangeCell.Change]()
        
        for i in 0...8 {
            for j in 0...8 {
                let blockIndex = (i / 3) * 3 + (j / 3)
                let cellIndex = (i % 3) * 3 + (j % 3)
                if killerSudoku.unsolvedPuzzle[i][j] == 0 {
                    let mode: String = isChangeCorrect(row: i, col: j, number: killerSudoku.puzzle[i][j])
                    let blockIndexPath = IndexPath(item: blockIndex, section: 0)
                    let cellIndexPath = IndexPath(item: cellIndex, section: 0)
                    let changedCell = SudokuPlayModel.ChangeCell.Change(blockIndex: blockIndexPath, cellIndex: cellIndexPath, number: killerSudoku.puzzle[i][j], mode: mode)
                    changedCells.append(changedCell)
                }
            }
        }
        
        return changedCells
    }
    
    func isPlayFinished(_ request: SudokuPlayModel.CheckGameOver.Request) -> Bool {
        return killerSudoku.getTable() == killerSudoku.puzzle
    }
    
    func isPlayChallenge(_ request: SudokuPlayModel.CheckChallenge.Request) -> Bool {
        let isChallenge = UserDefaults.standard.bool(forKey: UserDefaultsKeys.sudokuChallengeGoes)
        return isChallenge
    }
    
    func gameIsWon(_ request: SudokuPlayModel.GameIsWon.Request) {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.sudokuChallengeGoes) {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.sudokuChallengeDone)
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.crownsChallengeDone) {
                CoreDataDatesStack.shared.saveDate(Date())
            }
        }
        
        playFinished(isWin: true)
        CoreDataSudokuStatisticStack.shared.recordWin(difficulty: killerSudoku.difficultyLevel, time: Int32(elapsedTime))
    }
    
    private func playFinished(isWin: Bool) {
        deinitTimer()
        presenter.routeGameOver(SudokuPlayModel.RouteGameOver.Response(isWin: isWin, time: elapsedTime))
    }
    
    func leaveGame(_ request: SudokuPlayModel.LeaveGame.Request) {
        deinitTimer()
        CoreDataSudokuProgressStack.shared.saveProgress(isTimerUsed: self.isTimerUsed,
                                                        initialTime: Int32(self.initialTime),
                                                        elapsedTime: Int32(self.elapsedTime),
                                                        killerSudoku: self.killerSudoku)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.unfinishedSudokuGame)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private func deinitTimer() {
        timeGoes = false
        timer?.invalidate()
        timer = nil
    }
    
    func saveMove(_ request: SudokuPlayModel.SaveMove.Request) {
        let (row, col) = getTablePosition(request.index)
        
        if savedMoves.count > 10 {
            savedMoves.remove(at: 0)
        }
        
        savedMoves.append(SudokuPlayModel.SudokuMove(index: request.index, value: killerSudoku.puzzle[row][col]))
    }
    
    func getLevelPictute(_ request: SudokuPlayModel.GetLevel.Request) {
        var image: UIImage?
        switch killerSudoku.difficultyLevel {
        case DifficultyLevels.hard:
            image = UIImage.hard
        case DifficultyLevels.medium:
            image = UIImage.medium
        default:
            image = UIImage.easy
        }
        
        presenter.setLevelImage(SudokuPlayModel.GetLevel.Response(image: image))
    }
}
