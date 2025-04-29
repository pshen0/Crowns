//
//  SudokuPlayInteractor.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

// MARK: - SudokuPlayBusinessLogic protocol
protocol SudokuPlayBusinessLogic {
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request)
    func cleanButtonTapped(_ request: SudokuPlayModel.DeleteCellNumber.Request)
    func pauseButtonTapped(_ request: SudokuPlayModel.PauseGame.Request)
    func hintButtonTapped(_ request: SudokuPlayModel.GetHint.Request)
    func undoButtonTapped(_ request: SudokuPlayModel.UndoMove.Request)
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeCellNumber.Request)
    
    func getCages(_ request: SudokuPlayModel.GetCages.Request) -> [SudokuCage]
    func determineCellsWithSum(_ request: SudokuPlayModel.DetermineCellsWithSum.Request) -> SudokuPlayModel.DetermineCellsWithSum.ViewModel
    func isPlayFinished(_ request: SudokuPlayModel.CheckGameOver.Request) -> Bool
    func isPlayChallenge(_ request: SudokuPlayModel.CheckChallenge.Request) -> Bool
    func gameIsWon(_ request: SudokuPlayModel.GameIsWon.Request)
    func timeIsUp() -> Bool
    func leaveGame(_ request: SudokuPlayModel.LeaveGame.Request)
    func saveMove(_ request: SudokuPlayModel.SaveMove.Request)
    
    func startTimer(_ request: SudokuPlayModel.StartTimer.Request)
    func getLevelPictute(_ request: SudokuPlayModel.GetLevel.Request)
}

// MARK: - SudokuPlayInteractor class
final class SudokuPlayInteractor: SudokuPlayBusinessLogic {
    
    // MARK: - Properties
    private let presenter: SudokuPlayPresentationLogic
    private let killerSudoku: KillerSudoku
    private var elapsedTime: Int
    private var initialTime: Int
    private var isTimerUsed: Bool
    private var timer: Timer? = Timer()
    private var timeGoes: Bool = true
    private var savedMoves: [SudokuPlayModel.SudokuMove] = []
    private let size = Constants.size
    
    // MARK: - Lifecycle
    init(presenter: SudokuPlayPresentationLogic, foundation: SudokuPlayModel.BuildModule.BuildFoundation) {
        self.presenter = presenter
        self.killerSudoku = foundation.killerSudoku
        self.initialTime = foundation.initialTime
        self.elapsedTime = foundation.elapsedTime
        self.isTimerUsed = foundation.isTimerUsed
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Funcs
    func backButtonTapped(_ request: SudokuPlayModel.RouteBack.Request) {
        deinitTimer()
        presenter.routeBack(SudokuPlayModel.RouteBack.Response())
    }
    
    func cleanButtonTapped(_ request: SudokuPlayModel.DeleteCellNumber.Request) {
        var changedCells = [SudokuPlayModel.ChangeCell.Change]()
        let (row, col) = getTablePosition(request.index)
        
        if killerSudoku.unsolvedPuzzle[row][col] == 0 {
            killerSudoku.puzzle[row][col] = 0
            let blockIndex = (row / size) * size + (col / size)
            let cellIndex = (row % size) * size + (col % size)
            let blockIndexPath = IndexPath(item: blockIndex, section: 0)
            let cellIndexPath = IndexPath(item: cellIndex, section: 0)
            let changedCell = SudokuPlayModel.ChangeCell.Change(blockIndex: blockIndexPath, cellIndex: cellIndexPath, number: 0, mode: SudokuCellMode.correct)
            changedCells.append(changedCell)
            
            changedCells = findChanges()
        }
        
        presenter.setPlaygroundChanges(SudokuPlayModel.ChangeCell.Response(changes: changedCells))
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
        for i in 0..<Constants.tableSize {
            for j in 0..<Constants.tableSize {
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
    
    func numberButtonTapped(_ request: SudokuPlayModel.ChangeCellNumber.Request) {
        var changedCells = [SudokuPlayModel.ChangeCell.Change]()
        let (row, col) = getTablePosition(request.index)
        
        if killerSudoku.unsolvedPuzzle[row][col] == 0 {
            killerSudoku.puzzle[row][col] = request.number
            changedCells = findChanges()
        }
        
        presenter.setPlaygroundChanges(SudokuPlayModel.ChangeCell.Response(changes: changedCells))
    }
    
    func getCages(_ request: SudokuPlayModel.GetCages.Request) -> [SudokuCage] {
        let cages = killerSudoku.getCages()
        return cages
    }
    
    func determineCellsWithSum(_ request: SudokuPlayModel.DetermineCellsWithSum.Request) -> SudokuPlayModel.DetermineCellsWithSum.ViewModel {
        let blockRow = request.index / size
        let blockCol = request.index % size
        var blockData: [Int] = []
        var initData: [Int] = []
        var cellsWithSum = [(IndexPath, Int)]()
        
        for i in 0 ..< size {
            for j in 0 ..< size {
                let row = blockRow * size + i
                let col = blockCol * size + j
                blockData.append(killerSudoku.puzzle[row][col])
                initData.append(killerSudoku.unsolvedPuzzle[row][col])
            }
        }
        
        for cage in killerSudoku.getCages() {
            if let minCageCell = cage.getCells().min(by: {
                $0.row < $1.row || ($0.row == $1.row && $0.col < $1.col)
            }) {
                let blockIndex = (minCageCell.row / size) * size + (minCageCell.col / size)
                let cellIndex = (minCageCell.row % size) * size + (minCageCell.col) % size
                
                if blockIndex == request.index {
                    let cellIndexPath = IndexPath(item: cellIndex, section: 0)
                    cellsWithSum.append((cellIndexPath, cage.getSum()))
                }
            }
        }
        
        return SudokuPlayModel.DetermineCellsWithSum.ViewModel(cellsWithSum: cellsWithSum, blockData: blockData, initData: initData)
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
    
    func timeIsUp() -> Bool {
        return elapsedTime >= initialTime && isTimerUsed
    }
    
    func leaveGame(_ request: SudokuPlayModel.LeaveGame.Request) {
        deinitTimer()
        CoreDataSudokuProgressStack.shared.saveProgress(isTimerUsed: self.isTimerUsed,
                                                        initialTime: Int32(self.initialTime),
                                                        elapsedTime: Int32(self.elapsedTime),
                                                        killerSudoku: self.killerSudoku)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.unfinishedSudokuGame)
    }
    
    func saveMove(_ request: SudokuPlayModel.SaveMove.Request) {
        let (row, col) = getTablePosition(request.index)
        
        if savedMoves.count > Constants.undoNumbers {
            savedMoves.remove(at: 0)
        }
        
        savedMoves.append(SudokuPlayModel.SudokuMove(index: request.index, value: killerSudoku.puzzle[row][col]))
    }
    
    func startTimer(_ request: SudokuPlayModel.StartTimer.Request) {
        initTimer()
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
    
    // MARK: - Private funcs
    private func initTimer() {
        timeGoes = true
        if isTimerUsed {
            timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(reverseTimeChange), userInfo: nil, repeats: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(forwardTimeChange), userInfo: nil, repeats: true)
        }
    }
    
    private func isChangeCorrect(row: Int, col: Int, number: Int) -> String {
        if number == 0 {
            return SudokuCellMode.correct
        }
        for i in 0..<Constants.tableSize {
            if i != col &&  i != row {
                if killerSudoku.getPuzzle()[row][i] == number ||  killerSudoku.getPuzzle()[i][col] == number {
                    return SudokuCellMode.incorrect
                }
            }
        }
        
        for i in (row / size * size)...(row / size * size + 2) {
            for j in (col / size * size)...(col / size * size + 2) {
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
        var row = (position / (Constants.tableSize * size)) * size
        position = position % (Constants.tableSize * size)
        var col = (position / Constants.tableSize) * size
        position = position % Constants.tableSize
        row += position / size
        col += position % size
        return (row, col)
    }
    
    private func findChanges() -> [SudokuPlayModel.ChangeCell.Change] {
        var changedCells = [SudokuPlayModel.ChangeCell.Change]()
        
        for i in 0..<Constants.tableSize {
            for j in 0..<Constants.tableSize {
                let blockIndex = (i / size) * size + (j / size)
                let cellIndex = (i % size) * size + (j % size)
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

    private func playFinished(isWin: Bool) {
        deinitTimer()
        presenter.routeGameOver(SudokuPlayModel.RouteGameOver.Response(isWin: isWin, time: elapsedTime))
    }
    
    private func deinitTimer() {
        timeGoes = false
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Actions
    @objc private func reverseTimeChange() {
        if initialTime - elapsedTime > 0 {
            elapsedTime += Constants.timeStep
            presenter.presentTime(SudokuPlayModel.SetTime.Response(time: initialTime - elapsedTime))
        } else {
            playFinished(isWin: false)
        }
    }
    
    @objc private func forwardTimeChange() {
        elapsedTime += Constants.timeStep
        presenter.presentTime(SudokuPlayModel.SetTime.Response(time: elapsedTime))
    }
    
    // MARK: - Constants
    private enum Constants {
        static let size = 3
        static let tableSize = 9
        static let undoNumbers = 10
        static let timeInterval = 1.0
        static let timeStep = 1
    }
}
