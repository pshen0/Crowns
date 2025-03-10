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

final class SudokuGrid {
    let n: Int
    var table: [[Int]]
    var cages: [SudokuCage] = []
    
    init(n: Int = 3) {
        self.n = n
        self.table = Array(repeating: Array(repeating: 0, count: n * n), count: n * n)
        generateBaseTable()
        mix()
        generateCages()
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
    
    func showCages() {
        for cage in cages {
            print("Sum: \(cage.sum), Cells: \(cage.cells)")
        }
    }
}
