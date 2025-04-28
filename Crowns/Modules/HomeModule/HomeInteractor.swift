//
//  Interactor.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

protocol HomeBusinessLogic {
    func playCrownsTapped(_ request: HomeModel.RouteToCrownsSettings.Request)
    func playSudokuTapped(_ request: HomeModel.RouteToSudokuSettings.Request)
    func learnCrownsTapped(_ request: HomeModel.RouteToCrownsLearning.Request)
    func learnSudokuTapped(_ request: HomeModel.RouteToSudokuLearning.Request)
    func getUnfinishedCrownsGame(_ request: HomeModel.GetUnfinishedCrownsGame.Request)
    func getUnfinishedSudokuGame(_ request: HomeModel.GetUnfinishedSudokuGame.Request)
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
    
     func learnCrownsTapped(_ request: HomeModel.RouteToCrownsLearning.Request) {
        presenter.routeToCrownsLearning(HomeModel.RouteToCrownsLearning.Response())
    }
    
     func learnSudokuTapped(_ request: HomeModel.RouteToSudokuLearning.Request) {
        presenter.routeToSudokuLearning(HomeModel.RouteToSudokuLearning.Response())
    }
    
    func getUnfinishedCrownsGame(_ request: HomeModel.GetUnfinishedCrownsGame.Request) {
        if let unfinishedCrownsGame = CoreDataCrownsProgressStack.shared.fetchProgress() {
            presenter.showUnfinishedCrowns(HomeModel.GetUnfinishedCrownsGame.Response(foundation: unfinishedCrownsGame))
        }
    }
    
    func getUnfinishedSudokuGame(_ request: HomeModel.GetUnfinishedSudokuGame.Request) {
        if let unfinishedSudokuGame = CoreDataSudokuProgressStack.shared.fetchProgress() {
            presenter.showUnfinishedSudoku(HomeModel.GetUnfinishedSudokuGame.Response(foundation: unfinishedSudokuGame))
        }
    }
}
