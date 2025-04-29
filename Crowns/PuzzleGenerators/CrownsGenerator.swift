//
//  CrownsGenerator.swift
//  Crowns
//
//  Created by Анна Сазонова on 15.03.2025.
//

import UIKit

// MARK: - CrownsCell struct
struct CrownsCell: Codable {
    let row: Int
    let col: Int
    var color: UIColorCodable
    var hasCrown: Bool = false
}

// MARK: - UIColorCodable struct
struct UIColorCodable: Codable & Equatable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(_ color: UIColor) {
        red = color.cgColor.components?[0] ?? 0
        green = color.cgColor.components?[1] ?? 0
        blue = color.cgColor.components?[2] ?? 0
        alpha = color.cgColor.alpha
    }
}

// MARK: - Cell struct
struct Cell: Hashable {
    let row: Int
    let col: Int
}

// MARK: - CrownsCage struct
final class CrownsCage: Codable {
    var cells: [CrownsCell] = []
    
    init(cell: CrownsCell) {
        cells.append(cell)
    }
    
    func addCell(_ cell: CrownsCell) {
        cells.append(cell)
    }
}

// MARK: - Crowns class
final class Crowns: Codable {
    // MARK: - Properties
    var size = Constants.size
    var table: [[CrownsCell]] = []
    var puzzle: [[CrownsCell]] = []
    var cages: [CrownsCage] = []
    let difficultyLevel: String
    private var crownsCells: [CrownsCell] = []
    private var singleCellZonesTarget: Int = 0
    
    // MARK: - Lifecycle
    init(_ difficultyLevel: String) {
        self.difficultyLevel = difficultyLevel
        
        switch difficultyLevel {
        case DifficultyLevels.easy:
            singleCellZonesTarget = 0
        case DifficultyLevels.medium:
            singleCellZonesTarget = 1
        case DifficultyLevels.hard:
            singleCellZonesTarget = 2
        default:
            singleCellZonesTarget = 0
        }
        
        print(self.difficultyLevel, singleCellZonesTarget)
        
        generateTable()
        generateCages()
        removeCrowns()
        CoreDataCrownsStatisticStack.shared.recordGameStarted()
    }
    
    // MARK: - Private funcs
    // Generate base table
    private func generateTable() {
        var tempTable: [[CrownsCell]] = []
        
        for row in 0..<size {
            var rowCells: [CrownsCell] = []
            for col in 0..<size {
                rowCells.append(CrownsCell(row: row, col: col, color: Colors.CrownsColors.clear))
            }
            tempTable.append(rowCells)
        }
        
        self.table = tempTable
    }
    
    // Generate cages
    private func generateCages() {
        var queensCoord: [Int: Int] = [:]
        var skippedCells = 0
        var colOrder = Array(0..<size)
        let colors: [UIColorCodable] = [Colors.CrownsColors.blue, Colors.CrownsColors.green, Colors.CrownsColors.lightBlue,
                                        Colors.CrownsColors.lightGreen, Colors.CrownsColors.orange, Colors.CrownsColors.purple,
                                        Colors.CrownsColors.pink, Colors.CrownsColors.red, Colors.CrownsColors.yellow]
        
        var isColOrderGood = false
        while !isColOrderGood {
            colOrder.shuffle()
            isColOrderGood = true
            for i in 0..<size - 1 {
                if abs(colOrder[i] - colOrder[i + 1]) < Constants.minDistance {
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
        let cellsToSkip = findCellsToSkip(in: colorGrid)
        
        while isElemIn2DArray(-1, arr: colorGrid) {
            var color: Int = -1
            var randRow: Int = 0
            var randCol: Int = 0
            while color == -1 {
                randRow = Int.random(in: 0..<size)
                randCol = Int.random(in: 0..<size)
                if cellsToSkip.contains(where: { $0.0 == randRow && $0.1 == randCol }) {
                    continue
                }
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
    
    // Try to remove crowns
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
        
        var crownsToRemove = Constants.crownsToRemove
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
    
    // Try to solve puzzle and check the only solution
    private func isSolvable() -> Bool {
        var placements: [[Bool]] = []
        for _ in 0..<size {
            let row = Array(repeating: true, count: size)
            placements.append(row)
        }
        let isSolved = solve(&placements)
        
        return isSolved
    }
    
    // Solve puzzle
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
                fillNeighbors(&placements)
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
    
    // Count crowns in row
    private func inRow(_ placements: inout [[Bool]], row: Int) -> Bool {
        var counter = 0
        for i in 0..<size {
            if placements[row][i] {
                counter += 1
            }
            
        }
        return (counter == 1)
    }
    
    // Count crowns in col
    private func inCol(_ placements: inout [[Bool]], col: Int) -> Bool {
        var counter = 0
        for i in 0..<size {
            if placements[i][col] {
                counter += 1
            }
            
        }
        return (counter == 1)
    }
    
    // Count crowns in cage
    private func inCage(_ placements: inout [[Bool]], row: Int, col: Int) -> Bool {
        var counter = 0
        var tempCage: CrownsCage = CrownsCage(cell: CrownsCell(row: 0, col: 0, color: Colors.CrownsColors.clear))
        
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
    
    // Marks the row as impossible to place the crown on
    private func fillRow(_ placements: inout [[Bool]], row: Int) {
        for i in 0..<size {
            placements[row][i] = false
        }
    }
    
    // Marks the col as impossible to place the crown on
    private func fillCol(_ placements: inout [[Bool]], col: Int) {
        for i in 0..<size {
            placements[i][col] = false
        }
    }
    
    // Marks the cage as impossible to place the crown on
    private func fillCage(_ placements: inout [[Bool]], row: Int, col: Int) {
        var tempCage: CrownsCage = CrownsCage(cell: CrownsCell(row: 0, col: 0, color: Colors.CrownsColors.clear))
        
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
        
        let directions = Constants.diagonalDirections
        
        for (dx, dy) in directions {
            let newRow = row + dx
            let newCol = col + dy
            
            if newRow >= 0, newRow < size, newCol >= 0, newCol < size, newRow < size {
                placements[newRow][newCol] = false
            }
        }
    }
    
    // Marks the neighbors as impossible to place the crown on
    private func fillNeighbors(_ placements: inout [[Bool]]) {
        for cage in cages {
            var allNeighbors: [Set<Cell>] = []
            
            for cell in cage.cells {
                if placements[cell.row][cell.col] {
                    let neighbors = getNeighbors(row: cell.row, col: cell.col)
                    allNeighbors.append(neighbors)
                }
            }
            
            if !allNeighbors.isEmpty {
                var commonNeighbors: Set<Cell> = allNeighbors[0]
                
                for tempNeighbors in allNeighbors {
                    commonNeighbors = commonNeighbors.intersection(tempNeighbors)
                }
                
                for cell in commonNeighbors {
                    placements[cell.row][cell.col] = false
                }
            }
        }
    }
    
    // Get all neighbors for the cell
    private func getNeighbors(row: Int, col: Int) -> Set<Cell> {
        var neighbors: Set<Cell> = []
        
        let directions: [(Int, Int)] = Constants.allDirections
        for (dx, dy) in directions {
            let newRow = row + dx
            let newCol = col + dy
            if newRow >= 0, newRow < size, newCol >= 0, newCol < size {
                neighbors.insert(Cell(row: newRow, col: newCol))
            }
        }
        
        return neighbors
    }
    
    private func isElemIn2DArray(_ elem: Int, arr: [[Int]]) -> Bool {
        for row in arr {
            if row.contains(elem) {
                return true
            }
        }
        return false
    }
    
    private func findCellsToSkip(in array: [[Int]]) -> [(Int, Int)] {
        var validIndices: [(Int, Int)] = []
        var result: [(Int, Int)] = []
        
        for row in 0..<array.count {
            for col in 0..<array[row].count {
                if array[row][col] != -1 {
                    validIndices.append((row, col))
                }
            }
        }
        
        validIndices.shuffle()
        if validIndices.count >= singleCellZonesTarget {
            for i in 0..<singleCellZonesTarget {
                result.append(validIndices[i])
            }
        }
        
        return result
    }
    
    // MARK: - Constants
    private enum Constants {
        static let crownsToRemove: Int = 9
        static let size = 9
        static let minDistance = 2
        
        static let diagonalDirections = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
        static let allDirections = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
    }
}



