//
//  UnfinishedSudokuBuilder.swift
//  Crowns
//
//  Created by Анна Сазонова on 16.04.2025.
//

import Foundation

import UIKit

enum UnfinishedSudokuBuilder {
    static func build(foundation: UnfinishedSudokuModel.BuildModule.BuildFoundation) -> UnfinishedSudokuViewController {
        let presenter = UnfinishedSudokuPresenter()
        let interactor = UnfinishedSudokuInteractor(presenter: presenter, foundation: foundation)
        let view = UnfinishedSudokuViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
