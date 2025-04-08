//
//  CrownsGenerator.swift
//  Crowns
//
//  Created by Анна Сазонова on 15.03.2025.
//

import UIKit

enum CrownsConstants {
    static let crownsToRemove: Int = 7
    static let directions = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
}

struct CrownsCell: Hashable {
    let row: Int
    let col: Int
    var color: UIColor
    var hasCrown: Bool = false
}

final class CrownsCage {
    var cells: [CrownsCell] = []
    
    init(cell: CrownsCell) {
        cells.append(cell)
    }
    
    func addCell(_ cell: CrownsCell) {
        cells.append(cell)
    }
}

final class Crowns {
    let size = 9
    var table: [[CrownsCell]] = []
    var puzzle: [[CrownsCell]] = []
    var cages: [CrownsCage] = []
    private var crownsCells: [CrownsCell] = []
    
    init() {
        generateTable()
        generateCages()
        removeCrowns()
    }
    
    private func generateTable() {
        var tempTable: [[CrownsCell]] = []
        
        for row in 0..<size {
            var rowCells: [CrownsCell] = []
            for col in 0..<size {
                rowCells.append(CrownsCell(row: row, col: col, color: .clear))
            }
            tempTable.append(rowCells)
        }
        
        self.table = tempTable
    }

    private func generateCages() {
        var queensCoord: [Int: Int] = [:]
        var colOrder = Array(0..<size)
        let colors: [UIColor] = [Colors.CrownsColors.blue, Colors.CrownsColors.green, Colors.CrownsColors.lightBlue,
                                 Colors.CrownsColors.lightGreen, Colors.CrownsColors.orange, Colors.CrownsColors.purple,
                                 Colors.CrownsColors.pink, Colors.CrownsColors.red, Colors.CrownsColors.yellow]
        
        var isColOrderGood = false
        while !isColOrderGood {
            colOrder.shuffle()
            isColOrderGood = true
            for i in 0..<size - 1 {
                if abs(colOrder[i] - colOrder[i + 1]) <= 2 {
                    isColOrderGood = false
                    break
                }
            }
        }

        for i in 0..<size {
            queensCoord[i] = colOrder[i]
        }

        var colorGrid: [[Int]] = []
        for i in 0..<size {
            var tempRow: [Int] = []
            for j in 0..<size {
                if queensCoord[i] == j {
                    tempRow.append(i)
                } else {
                    tempRow.append(-1)
                }
            }
            colorGrid.append(tempRow)
        }
        
        let crownsPositions = colorGrid
        
        while isElemIn2DArray(-1, arr: colorGrid) {
            var color: Int = -1
            var randRow: Int = 0
            var randCol: Int = 0
            while color == -1 {
                randRow = Int.random(in: 0..<size)
                randCol = Int.random(in: 0..<size)
                color = colorGrid[randRow][randCol]
            }
            
            var neighborhood: [[Int]] = []
            if randRow > 0 { neighborhood.append([randRow - 1, randCol]) }
            if randRow < size - 1 { neighborhood.append([randRow + 1, randCol]) }
            if randCol > 0 { neighborhood.append([randRow, randCol - 1]) }
            if randCol < size - 1 { neighborhood.append([randRow, randCol + 1]) }

            let uncoloredNeighborhood = neighborhood.filter { colorGrid[$0[0]][$0[1]] == -1 }
            
            if !uncoloredNeighborhood.isEmpty {
                let chosenNeighbor = uncoloredNeighborhood.randomElement() ?? uncoloredNeighborhood[0]
                colorGrid[chosenNeighbor[0]][chosenNeighbor[1]] = color
            }
        }

        var tempCages: [CrownsCage] = []
        for row in 0..<size {
            for col in 0..<size {
                let color = colors[colorGrid[row][col]]
                table[row][col].color = color
                table[row][col].hasCrown = false
                if crownsPositions[row][col] != -1 {
                    table[row][col].hasCrown = true
                }
                
                if !tempCages.contains(where: { $0.cells.contains(where: { $0.color == table[row][col].color }) }) {
                    let newCage = CrownsCage(cell: table[row][col])
                    tempCages.append(newCage)
                } else {
                    for cage in tempCages {
                        for cell in cage.cells {
                            if cell.color == table[row][col].color {
                                cage.addCell(table[row][col])
                                break
                            }
                        }
                    }
                }
            }
        }
        
        cages = tempCages
    }
    
    private func removeCrowns() {
        puzzle = table.map { row in
            row.map { cell in
                CrownsCell(row: cell.row, col: cell.col, color: cell.color, hasCrown: cell.hasCrown)
            }
        }
        
        var removableCells: [CrownsCell] = []
        for i in 0..<size {
            for j in 0..<size {
                if puzzle[i][j].hasCrown == true {
                    crownsCells.append(puzzle[i][j])
                    removableCells.append(puzzle[i][j])
                }
            }
        }
        
        removableCells.shuffle()
        
        var crownsToRemove = CrownsConstants.crownsToRemove
        while !removableCells.isEmpty && crownsToRemove > 0 {
            let cell = removableCells[0]
            puzzle[cell.row][cell.col].hasCrown = false
            if !isSolvable() {
                puzzle[cell.row][cell.col].hasCrown = true
            } else {
                crownsToRemove -= 1
            }
            removableCells.remove(at: 0)
        }
    }
    
    private func isSolvable() -> Bool {
        var placements: [[Bool]] = []
        for _ in 0..<size {
            let row = Array(repeating: true, count: size)
            placements.append(row)
        }
        let isSolved = solve(&placements)
        
        return isSolved
    }
    
    private func solve(_ placements: inout [[Bool]]) -> Bool {
        var tempBoard = puzzle.map { row in
            row.map { cell in
                CrownsCell(row: cell.row, col: cell.col, color: cell.color, hasCrown: cell.hasCrown)
            }
        }
        var emptyCrown = 0
        for cell in crownsCells {
            if tempBoard[cell.row][cell.col].hasCrown == true {
                fillRow(&placements, row: cell.row)
                fillCol(&placements, col: cell.col)
                fillCage(&placements, row: cell.row, col: cell.col)
            } else {
                emptyCrown += 1
            }
        }

        var counter = 0
        
        func checkCrown() {
            if counter == emptyCrown {
                return
            }
            var wasFounded = false
            for cell in crownsCells {
                if tempBoard[cell.row][cell.col].hasCrown == false {
                    if inRow(&placements, row: cell.row) == true ||
                        inCol(&placements, col: cell.col) == true ||
                        inCage(&placements, row: cell.row, col: cell.col) == true {
                        fillRow(&placements, row: cell.row)
                        fillCol(&placements, col: cell.col)
                        fillCage(&placements, row: cell.row, col: cell.col)
                        tempBoard[cell.row][cell.col].hasCrown = true
                        wasFounded = true
                        counter += 1
                    }
                }
            }
            
            if wasFounded {
                checkCrown()
            } else {
                return
            }
        }
        
        checkCrown()
        return counter == emptyCrown
    }
    
    private func inRow(_ placements: inout [[Bool]], row: Int) -> Bool {
        var counter = 0
        for i in 0..<size {
            if placements[row][i] {
                counter += 1
            }
            
        }
        return (counter == 1)
    }
    
    private func inCol(_ placements: inout [[Bool]], col: Int) -> Bool {
        var counter = 0
        for i in 0..<size {
            if placements[i][col] {
                counter += 1
            }
            
        }
        return (counter == 1)
    }
    
    private func inCage(_ placements: inout [[Bool]], row: Int, col: Int) -> Bool {
        var counter = 0
        var tempCage: CrownsCage = CrownsCage(cell: CrownsCell(row: 0, col: 0, color: .clear))
        
        for cage in cages {
            for cell in cage.cells {
                if cell.row == row && cell.col == col {
                    tempCage = cage
                }
            }
        }
        
        for cell in tempCage.cells {
            if placements[cell.row][cell.col] {
                counter += 1
            }
        }

        return (counter == 1)
    }
    
    private func fillRow(_ placements: inout [[Bool]], row: Int) {
        for i in 0..<size {
            placements[row][i] = false
        }
    }
    
    private func fillCol(_ placements: inout [[Bool]], col: Int) {
        for i in 0..<size {
            placements[i][col] = false
        }
    }
    
    private func fillCage(_ placements: inout [[Bool]], row: Int, col: Int) {
        var tempCage: CrownsCage = CrownsCage(cell: CrownsCell(row: 0, col: 0, color: .clear))
        
        for cage in cages {
            for cell in cage.cells {
                if cell.row == row && cell.col == col {
                    tempCage = cage
                }
            }
        }
        
        for cell in tempCage.cells {
            placements[cell.row][cell.col] = false
        }
        
        let directions = CrownsConstants.directions
        
        for (dx, dy) in directions {
            let newRow = row + dx
            let newCol = col + dy

            if newRow >= 0, newRow < size, newCol >= 0, newCol < size, newRow < size {
                placements[newRow][newCol] = false
            }
        }
    }

    private func isElemIn2DArray(_ elem: Int, arr: [[Int]]) -> Bool {
        for row in arr {
            if row.contains(elem) {
                return true
            }
        }
        return false
    }
}



