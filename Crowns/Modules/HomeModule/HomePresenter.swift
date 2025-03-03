//
//  Presenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

protocol HomePresentationLogic {
    func routeToCrownsSettings(_ response: HomeModel.RouteToCrownsSettings.Response)
    func routeToSudokuSettings(_ response: HomeModel.RouteToSudokuSettings.Response)
    func routeToQueensSettings(_ response: HomeModel.RouteToQueensSettings.Response)
    func routeToCrownsLearning(_ response: HomeModel.RouteToCrownsLearning.Response)
    func routeToSudokuLearning(_ response: HomeModel.RouteToSudokuLearning.Response)
    func routeToQueensLearning(_ response: HomeModel.RouteToQueensLearning.Response)
}

final class HomePresenter: HomePresentationLogic {
    
    weak var view: HomeViewController?
    
    func routeToCrownsSettings(_ response: HomeModel.RouteToCrownsSettings.Response) {
        view?.hideGameSelector()
        view?.navigationController?.pushViewController(CrownsSettingsBuilder.build(), animated: false)
    }
    
    func routeToSudokuSettings(_ response: HomeModel.RouteToSudokuSettings.Response) {
        view?.hideGameSelector()
        view?.navigationController?.pushViewController(SudokuSettingsBuilder.build(), animated: false)
    }
    
    func routeToQueensSettings(_ response: HomeModel.RouteToQueensSettings.Response) {
        view?.hideGameSelector()
        view?.navigationController?.pushViewController(QueensSettingsBuilder.build(), animated: false)
    }
    
    func routeToCrownsLearning(_ response: HomeModel.RouteToCrownsLearning.Response) {
        view?.hideLearningSelector()
        view?.navigationController?.pushViewController(CrownsLearningBuilder.build(), animated: false)
    }
    
    func routeToSudokuLearning(_ response: HomeModel.RouteToSudokuLearning.Response) {
        view?.hideLearningSelector()
        view?.navigationController?.pushViewController(SudokuLearningBuilder.build(), animated: false)
    }
    
    func routeToQueensLearning(_ response: HomeModel.RouteToQueensLearning.Response) {
        view?.hideLearningSelector()
        view?.navigationController?.pushViewController(QueensLearningBuilder.build(), animated: false)
    }
}
