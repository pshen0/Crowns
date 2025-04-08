//
//  SudokuCageOverlay.swift
//  Crowns
//
//  Created by Анна Сазонова on 10.03.2025.
//

import UIKit

final class CageOverlayView: UIView {
    private var cages: [SudokuCage] = []
    private var cellSize: CGFloat = 40
    
    init(_ generatedCages: Array<SudokuCage>, _ size: CGFloat) {
        super.init(frame: .zero)
        cages = generatedCages
        cellSize = size
        backgroundColor = .clear
        drawBorders()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    private func drawBorders() {
        for cage in cages {
            drawCageBorder(for: cage)
        }
    }
    
    private func drawCageBorder(for cage: SudokuCage) {
        let offsets: [(dx: Int, dy: Int)] = [(-1, 0), (0, -1)]
        
        for cell in cage.getCells() {
            let row = cell.row
            let col = cell.col
            
            let cellFrame = CGRect(
                x: CGFloat(col) * cellSize + 2 * (CGFloat(col) - 1 - CGFloat(col / 3)) + 5 * CGFloat(col / 3),
                y: CGFloat(row) * cellSize + 2 * (CGFloat(row) - 1 - CGFloat(row / 3)) + 5 * CGFloat(row / 3),
                width: cellSize,
                height: cellSize
            )

            for (dx, dy) in offsets {
                let neighborRow = row + dy
                let neighborCol = col + dx
                
                if !cage.getCells().contains(where: { $0.row == neighborRow && $0.col == neighborCol }) {
                    let path = UIBezierPath()
                    var currentWidth: CGFloat = 1.0

                    if (row % 3 == 0 && dy == -1) || (row % 3 == 2 && dy == 1) ||
                       (col % 3 == 0 && dx == -1) || (col % 3 == 2 && dx == 1) {
                        currentWidth = 3.0
                    }

                    switch (dx, dy) {
                    case (-1, 0):
                        path.move(to: CGPoint(x: cellFrame.minX, y: cellFrame.minY))
                        path.addLine(to: CGPoint(x: cellFrame.minX, y: cellFrame.maxY))
                    case (0, -1):
                        path.move(to: CGPoint(x: cellFrame.minX, y: cellFrame.minY))
                        path.addLine(to: CGPoint(x: cellFrame.maxX, y: cellFrame.minY))
                    default:
                        break
                    }

                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = path.cgPath
                    shapeLayer.lineWidth = currentWidth
                    shapeLayer.strokeColor = Colors.white.cgColor
                    shapeLayer.fillColor = UIColor.clear.cgColor
                    shapeLayer.lineDashPattern = [10, 3]
                    
                    layer.addSublayer(shapeLayer)
                }
            }
        }
    }
}
