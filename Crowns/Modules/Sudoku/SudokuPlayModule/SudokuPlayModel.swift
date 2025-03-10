//
//  SudokuPlayRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

enum SudokuPlayModel {
    enum  RouteBack {
        struct Request { }
        struct Response { }
    }
    
    enum ChangeNumberCell {
        struct Request {
            let index: Int
        }
        struct Response {
            let index: Int
        }
        struct ViewModel {
            let arrayRow: Int
            let arrayCol: Int
            let blockIndexPath: IndexPath
            var blockIndex: Int
            var cellIndex: Int
        }
    }
}
