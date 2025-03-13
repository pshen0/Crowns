//
//  KillerSudokuGenerator.swift
//  Crowns
//
//  Created by Анна Сазонова on 05.03.2025.
//

import Foundation

struct Cell: Hashable {
    let row: Int
    let col: Int
    let value: Int
}

final class SudokuCage {
    var cells: [Cell] = []
    var sum: Int = 0
    
    init(cell: Cell) {
        cells.append(cell)
        sum += cell.value
    }
    
    func addCell(_ cell: Cell) {
        cells.append(cell)
        sum += cell.value
    }
}

final class KillerSudoku {
    let n: Int = 3
    let difficultyLevel: String
    var table: [[Int]]
    var cages: [SudokuCage] = []
    var puzzle: [[Int]]
    var unsolvedPuzzle: [[Int]]
    
    init(difficultyLeve: String) {
        self.difficultyLevel = difficultyLeve
        table = Array(repeating: Array(repeating: 0, count: n * n), count: n * n)
        puzzle = Array(repeating: Array(repeating: 0, count: n * n), count: n * n)
        unsolvedPuzzle = Array(repeating: Array(repeating: 0, count: n * n), count: n * n)
        
        generateBaseTable()
        mix()
        generateCages()
        generatePuzzle()
    }
    
    private func generateBaseTable() {
        for i in 0..<(n * n) {
            for j in 0..<(n * n) {
                table[i][j] = (i * n + i / n + j) % (n * n) + 1
            }
        }
    }
    
    func show() {
        print(table)
    }
    
    func transpose() {
        table = (0..<(n * n)).map { i in (0..<(n * n)).map { j in table[j][i] } }
    }
    
    func swapRowsSmall() {
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
    
    func swapColumnsSmall() {
        transpose()
        swapRowsSmall()
        transpose()
    }
    
    func swapRowsArea() {
        let area1 = Int.random(in: 0..<n)
        var area2 = Int.random(in: 0..<n)
        while area1 == area2 {
            area2 = Int.random(in: 0..<n)
        }
        for i in 0..<n {
            table.swapAt(area1 * n + i, area2 * n + i)
        }
    }
    
    func swapColumnsArea() {
        transpose()
        swapRowsArea()
        transpose()
    }
    
    func mix(_ amt: Int = 100) {
        let mixFunctions: [() -> Void] = [transpose, swapRowsSmall, swapColumnsSmall, swapRowsArea, swapColumnsArea]
        for _ in 0..<amt {
            mixFunctions.randomElement()?()
        }
    }
    
    private func generateCages() {
        var remainingCells = Set((0..<n*n).flatMap { row in (0..<n*n).map { col in Cell(row: row, col: col, value: table[row][col]) } })
        
        while !remainingCells.isEmpty {
            let startCell = remainingCells[remainingCells.startIndex]
            remainingCells.remove(startCell)
            let cage = SudokuCage(cell: startCell)
            
            let cageSize = Int.random(in: 2...5)
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
    
    private func generatePuzzle() {
        puzzle = table.map { $0 }
        var removedCells = Set<Cell>()
        var checkedPuzzles = Set<Cell>()
        
        removeCageCells(&removedCells, &checkedPuzzles)
        removeSymmetricCells(&removedCells, &checkedPuzzles)
        let indexes = Array(0..<9)
        while removedCells.count < 50 {
            let row = indexes.randomElement() ?? 0
            let col = indexes.randomElement() ?? 0
            tryDeleteCell(row, col, &removedCells, &checkedPuzzles)
        }
        unsolvedPuzzle = puzzle.map { $0 }
    }

    private func removeSymmetricCells(_ removedCells: inout Set<Cell>, _ checkedPuzzles: inout Set<Cell>) {
        let indexes = Array(0..<9)

        for i in 0..<9 {
            let col = indexes.randomElement()!
            tryDeleteCell(i, col, &removedCells, &checkedPuzzles)
            tryDeleteCell(8 - i, 8 - col, &removedCells, &checkedPuzzles)
        }

        for i in 0..<9 {
            let row = indexes.randomElement()!
            tryDeleteCell(row, i, &removedCells, &checkedPuzzles)
            tryDeleteCell(8 - row, 8 - i, &removedCells, &checkedPuzzles)
        }
    }

    private func removeCageCells(_ removedCells: inout Set<Cell>, _ checkedPuzzles: inout Set<Cell>) {
        for cage in cages {
            if let cell = cage.cells.randomElement() {
                let row = cell.row
                let col = cell.col
                tryDeleteCell(row, col, &removedCells, &checkedPuzzles)
            }
        }
    }

    private func tryDeleteCell(_ row: Int, _ col: Int, _ removedCells: inout Set<Cell>, _ checkedPuzzles: inout Set<Cell>) {
        guard puzzle[row][col] != 0 else { return }
        
        let value = puzzle[row][col]
        puzzle[row][col] = 0
        let cell = Cell(row: row, col: col, value: value)
        
        if checkedPuzzles.contains(cell) || !hasUniqueSolution(puzzle) {
            puzzle[row][col] = value
        } else {
            removedCells.insert(cell)
            
        }
        checkedPuzzles.insert(cell)
    }
    
    private func hasUniqueSolution(_ puzzle: [[Int]]) -> Bool {
        var solutionCount = 0

        func solve(_ board: inout [[Int]], _ row: Int, _ col: Int) -> Bool {
            if row == 9 {
                solutionCount += 1
                return solutionCount > 1
            }

            let nextRow = (col == 8) ? row + 1 : row
            let nextCol = (col + 1) % 9

            if board[row][col] != 0 {
                return solve(&board, nextRow, nextCol)
            }

            for num in 1...9 {
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
    
    private func isValid(_ board: [[Int]], _ row: Int, _ col: Int, _ num: Int) -> Bool {
        for i in 0..<9 {
            if board[row][i] == num || board[i][col] == num {
                return false
            }
        }
        
        let startRow = (row / 3) * 3
        let startCol = (col / 3) * 3
        for i in 0..<3 {
            for j in 0..<3 {
                if board[startRow + i][startCol + j] == num {
                    return false
                }
            }
        }
        return true
    }
}
