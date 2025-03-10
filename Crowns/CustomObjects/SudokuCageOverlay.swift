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
        for cage in cages {
            print(cage.cells)
        }
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
        let offsets: [(dx: Int, dy: Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        
        for cell in cage.cells {
            let row = cell.row
            let col = cell.col
            
            let cellFrame = CGRect(
                x: CGFloat(col) * cellSize,
                y: CGFloat(row) * cellSize,
                width: cellSize,
                height: cellSize
            )

            for (dx, dy) in offsets {
                let neighborRow = row + dy
                let neighborCol = col + dx
                
                // Проверяем, существует ли соседняя клетка в пределах одной секции
                if !cage.cells.contains(where: { $0.row == neighborRow && $0.col == neighborCol }) {
                    let path = UIBezierPath()
                    var currentWidth: CGFloat = 2.0  // Стандартная ширина линии для внутренней границы

                    // Увеличиваем ширину линии, если клетка на границе между секциями
                    if (row % 3 == 0 && dy == -1) || (row % 3 == 2 && dy == 1) ||
                       (col % 3 == 0 && dx == -1) || (col % 3 == 2 && dx == 1) {
                        currentWidth = 5.0  // Ширина линии между секциями
                    }
                    
                    // Сдвигаем линии на половину ширины линии, чтобы граница рисовалась снаружи
                    let offset = currentWidth / 2

                    switch (dx, dy) {
                    case (-1, 0):  // Левая граница
                        path.move(to: CGPoint(x: cellFrame.minX - offset, y: cellFrame.minY))
                        path.addLine(to: CGPoint(x: cellFrame.minX - offset, y: cellFrame.maxY))
                    case (1, 0):   // Правая граница
                        path.move(to: CGPoint(x: cellFrame.maxX + offset, y: cellFrame.minY))
                        path.addLine(to: CGPoint(x: cellFrame.maxX + offset, y: cellFrame.maxY))
                    case (0, -1):  // Верхняя граница
                        path.move(to: CGPoint(x: cellFrame.minX, y: cellFrame.minY - offset))
                        path.addLine(to: CGPoint(x: cellFrame.maxX, y: cellFrame.minY - offset))
                    case (0, 1):   // Нижняя граница
                        path.move(to: CGPoint(x: cellFrame.minX, y: cellFrame.maxY + offset))
                        path.addLine(to: CGPoint(x: cellFrame.maxX, y: cellFrame.maxY + offset))
                    default:
                        break
                    }

                    // Создаём CAShapeLayer для отображения границы
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = path.cgPath
                    shapeLayer.lineWidth = currentWidth
                    shapeLayer.strokeColor = Colors.white.withAlphaComponent(0.6).cgColor
                    shapeLayer.fillColor = UIColor.clear.cgColor
                    
                    // Добавляем слой на view
                    layer.addSublayer(shapeLayer)
                }
            }
        }
    }
}
