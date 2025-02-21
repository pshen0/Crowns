//
//  Interactor.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

protocol HomeBusinessLogic {
     func playCrownsTapped(_ request: HomeModel.RouteToCrownsSettings.Request)
     func playSudokuTapped(_ request: HomeModel.RouteToSudokuSettings.Request)
     func playQueensTapped(_ request: HomeModel.RouteToQueensSettings.Request)
     func learnCrownsTapped(_ request: HomeModel.RouteToCrownsLearning.Request)
     func learnSudokuTapped(_ request: HomeModel.RouteToSudokuLearning.Request)
     func learnQueensTapped(_ request: HomeModel.RouteToQueensLearning.Request)
}

final class HomeInteractor: HomeBusinessLogic {
    
     private let presenter: HomePresentationLogic
    
    init(presenter: HomePresentationLogic) {
        self.presenter = presenter
    }
    
     func playCrownsTapped(_ request: HomeModel.RouteToCrownsSettings.Request) {
        presenter.routeToCrownsSettings(HomeModel.RouteToCrownsSettings.Response())
    }
    
     func playSudokuTapped(_ request: HomeModel.RouteToSudokuSettings.Request) {
        presenter.routeToSudokuSettings(HomeModel.RouteToSudokuSettings.Response())
    }
    
     func playQueensTapped(_ request: HomeModel.RouteToQueensSettings.Request) {
        presenter.routeToQueensSettings(HomeModel.RouteToQueensSettings.Response())
    }
    
     func learnCrownsTapped(_ request: HomeModel.RouteToCrownsLearning.Request) {
        presenter.routeToCrownsLearning(HomeModel.RouteToCrownsLearning.Response())
    }
    
     func learnSudokuTapped(_ request: HomeModel.RouteToSudokuLearning.Request) {
        presenter.routeToSudokuLearning(HomeModel.RouteToSudokuLearning.Response())
    }
    
     func learnQueensTapped(_ request: HomeModel.RouteToQueensLearning.Request) {
        presenter.routeToQueensLearning(HomeModel.RouteToQueensLearning.Response())
    }
}
