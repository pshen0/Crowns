//
//  KillerSudokuGenerator.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.03.2025.
//

import Foundation

// MARK: - SudokuCell struct
struct SudokuCell: Hashable & Codable {
    let row: Int
    let col: Int
    let value: Int
}

// MARK: - SudokuCage class
final class SudokuCage: Codable {
    // MARK: - Properties
    private var cells: [SudokuCell] = []
    private var sum: Int = 0
    
    init(cell: SudokuCell) {
        cells.append(cell)
        sum += cell.value
    }
    
    // MARK: - Funcs
    // Add cell to cage
    func addCell(_ cell: SudokuCell) {
        cells.append(cell)
        sum += cell.value
    }
    
    // Get cage's cells
    func getCells() -> [SudokuCell] {
        return cells
    }
    
    // Get cage sum
    func getSum() -> Int {
        return sum
    }
}

// MARK: - Killer sudoku class
final class KillerSudoku: Codable {
    // MARK: - Properties
    private var size: Int = Constants.size
    private var n: Int = Constants.n
    let difficultyLevel: String
    var table: [[Int]]
    private var cages: [SudokuCage] = []
    var puzzle: [[Int]]
    var unsolvedPuzzle: [[Int]]
    private var removableCounter: Int = Constants.removableCounterEasy

    // MARK: - Lifecycle
    init(difficultyLevel: String) {
        self.difficultyLevel = difficultyLevel
        table = Array(repeating: Array(repeating: 0, count: size), count: size)
        puzzle = Array(repeating: Array(repeating: 0, count: size), count: size)
        unsolvedPuzzle = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        switch difficultyLevel {
        case DifficultyLevels.easy:
            removableCounter = Constants.removableCounterEasy
        case DifficultyLevels.medium:
            removableCounter = Constants.removableCounterMedium
        case DifficultyLevels.hard:
            removableCounter = Constants.removableCounterHard
        default:
            removableCounter = [Constants.removableCounterEasy,
                                Constants.removableCounterMedium,
                                Constants.removableCounterHard].randomElement() ?? Constants.removableCounterEasy
        }
        
        generateBaseTable()
        mix()
        generateCages()
        generatePuzzle()
        CoreDataSudokuStatisticStack.shared.recordGameStarted()
    }
    
    // MARK: - Funcs
    // Get sudoku puzzle
    func getPuzzle() -> [[Int]] {
        return puzzle
    }
    
    // Get sudoku cages
    func getCages() -> [SudokuCage] {
        return cages
    }
    
    // Get sudoku solved puzzle
    func getTable() -> [[Int]] {
        return table
    }
    
    // MARK: - Private funcs
    // Mix table to get sudoku solved puzzle
    private func mix(_ amt: Int = Constants.mixRepeat) {
        let mixFunctions: [() -> Void] = [transpose, swapRowsSmall, swapColumnsSmall, swapRowsArea, swapColumnsArea]
        for _ in 0..<amt {
            mixFunctions.randomElement()?()
        }
    }
    
    // Generate base sudoku table
    private func generateBaseTable() {
        for i in 0..<(size) {
            for j in 0..<(size) {
                table[i][j] = (i * n + i / n + j) % (size) + 1
            }
        }
    }
    
    // Transpose table
    private func transpose() {
        table = (0..<(size)).map { i in (0..<(size)).map { j in table[j][i] } }
    }
    
    // Swap two rows
    private func swapRowsSmall() {
        let area = Int.random(in: 0..<n)
        let line1 = Int.random(in: 0..<n)
        var line2 = Int.random(in: 0..<n)
        while line1 == line2 {
            line2 = Int.random(in: 0..<n)
        }
        let N1 = area * n + line1
        let N2 = area * n + line2
        table.swapAt(N1, N2)
    }
    
    // Swap two cols
    private func swapColumnsSmall() {
        transpose()
        swapRowsSmall()
        transpose()
    }
    
    // Swap two row areas
    private func swapRowsArea() {
        let area1 = Int.random(in: 0..<n)
        var area2 = Int.random(in: 0..<n)
        while area1 == area2 {
            area2 = Int.random(in: 0..<n)
        }
        for i in 0..<n {
            table.swapAt(area1 * n + i, area2 * n + i)
        }
    }
    
    // Swap two cols areas
    private func swapColumnsArea() {
        transpose()
        swapRowsArea()
        transpose()
    }
    
    // Genereate cages
    private func generateCages() {
        var remainingCells = Set((0..<size).flatMap { row in (0..<size).map { col in SudokuCell(row: row, col: col, value: table[row][col]) } })
        
        while !remainingCells.isEmpty {
            let startCell = remainingCells[remainingCells.startIndex]
            remainingCells.remove(startCell)
            let cage = SudokuCage(cell: startCell)
            
            let cageSize = Int.random(in: Constants.cageSizeMin...Constants.cageSizeMax)
            for _ in 1..<cageSize {
                let neighbors = remainingCells.filter {
                    abs($0.row - startCell.row) + abs($0.col - startCell.col) == 1
                }
                if let nextCell = neighbors.randomElement() {
                    cage.addCell(nextCell)
                    remainingCells.remove(nextCell)
                }
            }
            cages.append(cage)
        }
    }
    
    // Generate puzzle removing cell's numbers
    private func generatePuzzle() {
        puzzle = table.map { $0 }
        var remainingCells = Set((0..<size).flatMap { row in (0..<size).map { col in SudokuCell(row: row, col: col, value: table[row][col]) } })
        var removedCells = Set<SudokuCell>()
        var checkedPuzzles = Set<SudokuCell>()
        
        removeCageCells(&removedCells, &checkedPuzzles, &remainingCells)
        removeSymmetricCells(&removedCells, &checkedPuzzles, &remainingCells)
        while removedCells.count < removableCounter && remainingCells.count > 0 {
            if let cell = remainingCells.randomElement() {
                tryDeleteCell(cell.row, cell.col, &removedCells, &checkedPuzzles, &remainingCells)
            }
        }
        unsolvedPuzzle = puzzle.map { $0 }
    }
    
    // Try to remove symmetric cells
    private func removeSymmetricCells(_ removedCells: inout Set<SudokuCell>, _ checkedPuzzles: inout Set<SudokuCell>, _ remainingCells: inout Set<SudokuCell>) {
        let indexes = Array(0..<size)

        for i in 0..<size {
            let col = indexes.randomElement() ?? 0
            tryDeleteCell(i, col, &removedCells, &checkedPuzzles, &remainingCells)
            tryDeleteCell(size - 1 - i, size - 1 - col, &removedCells, &checkedPuzzles, &remainingCells)
        }

        for i in 0..<size {
            let row = indexes.randomElement() ?? 0
            tryDeleteCell(row, i, &removedCells, &checkedPuzzles, &remainingCells)
            tryDeleteCell(size - 1 - row, size - 1 - i, &removedCells, &checkedPuzzles, &remainingCells)
        }
    }
    
    // Try to remove cells in every cage
    private func removeCageCells(_ removedCells: inout Set<SudokuCell>, _ checkedPuzzles: inout Set<SudokuCell>, _ remainingCells: inout Set<SudokuCell>) {
        for cage in cages {
            if removedCells.count > removableCounter { break }
            if let cell = cage.getCells().randomElement() {
                let row = cell.row
                let col = cell.col
                tryDeleteCell(row, col, &removedCells, &checkedPuzzles, &remainingCells)
            }
        }
    }
    
    // Try to delete cell
    private func tryDeleteCell(_ row: Int, _ col: Int, _ removedCells: inout Set<SudokuCell>, _ checkedPuzzles: inout Set<SudokuCell>, _ remainingCells: inout Set<SudokuCell>) {
        guard puzzle[row][col] != 0 else { return }
        
        let value = puzzle[row][col]
        puzzle[row][col] = 0
        let cell = SudokuCell(row: row, col: col, value: value)
        
        if checkedPuzzles.contains(cell) || !hasUniqueSolution(puzzle) {
            puzzle[row][col] = value
        } else {
            removedCells.insert(cell)
            
        }
        checkedPuzzles.insert(cell)
        remainingCells.remove(cell)
    }
    
    // Try to solve puzzle and check the only solution
    private func hasUniqueSolution(_ puzzle: [[Int]]) -> Bool {
        var solutionCount = 0

        func solve(_ board: inout [[Int]], _ row: Int, _ col: Int) -> Bool {
            if row == size {
                solutionCount += 1
                return solutionCount > 1
            }
            
            if solutionCount > 1 { return false}

            let nextRow = (col == size - 1) ? row + 1 : row
            let nextCol = (col + 1) % size

            if board[row][col] != 0 {
                return solve(&board, nextRow, nextCol)
            }

            for num in 1...size {
                if isValid(board, row, col, num) {
                    board[row][col] = num
                    if solve(&board, nextRow, nextCol) {
                        return true
                    }
                    board[row][col] = 0
                }
            }
            return false
        }

        var tempBoard = puzzle
        _ = solve(&tempBoard, 0, 0)

        return solutionCount == 1
    }
    
    // Validation check
    private func isValid(_ board: [[Int]], _ row: Int, _ col: Int, _ num: Int) -> Bool {
        let boxRow = (row / n) * n
        let boxCol = (col / n) * n
        
        for i in 0..<size {
            if board[row][i] == num || board[i][col] == num || board[boxRow + i / n][boxCol + i % n] == num {
                return false
            }
        }
        return true
    }
    
    // MARK: - Constants
    private enum Constants {
        static let size: Int = 9
        static let n: Int = 3
        static let removableCounterEasy: Int = 45
        static let removableCounterMedium: Int = 50
        static let removableCounterHard: Int = 55
        static let mixRepeat: Int = 100
        static let cageSizeMin: Int = 2
        static let cageSizeMax: Int = 5
    }
}
