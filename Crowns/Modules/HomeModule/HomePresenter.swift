//
//  Presenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

protocol HomePresentationLogic {
    func routeToCrownsSettings(_ response: HomeModel.RouteToCrownsSettings.Response)
    func routeToSudokuSettings(_ response: HomeModel.RouteToSudokuSettings.Response)
    func routeToCrownsLearning(_ response: HomeModel.RouteToCrownsLearning.Response)
    func routeToSudokuLearning(_ response: HomeModel.RouteToSudokuLearning.Response)
    func showUnfinishedCrowns(_ response: HomeModel.GetUnfinishedCrownsGame.Response)
    func showUnfinishedSudoku(_ response: HomeModel.GetUnfinishedSudokuGame.Response)
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
    
    func routeToCrownsLearning(_ response: HomeModel.RouteToCrownsLearning.Response) {
        view?.hideLearningSelector()
        view?.navigationController?.pushViewController(CrownsLearningBuilder.build(), animated: false)
    }
    
    func routeToSudokuLearning(_ response: HomeModel.RouteToSudokuLearning.Response) {
        view?.hideLearningSelector()
        view?.navigationController?.pushViewController(SudokuLearningBuilder.build(), animated: false)
    }
    
    func showUnfinishedCrowns(_ response: HomeModel.GetUnfinishedCrownsGame.Response) {
        let foundation = response.foundation
        let responseFoundation: UnfinishedCrownsModel.BuildModule.BuildFoundation =
        UnfinishedCrownsModel.BuildModule.BuildFoundation(
            crowns: foundation.crowns,
            elapsedTime: foundation.elapsedTime,
            initialTime: foundation.initialTime,
            isTimerUsed: foundation.isTimerUsed,
            placements: foundation.placements)
        view?.showUnfinishedCrowns(responseFoundation)
    }
    
    func showUnfinishedSudoku(_ response: HomeModel.GetUnfinishedSudokuGame.Response) {
        let foundation = response.foundation
        let responseFoundation: UnfinishedSudokuModel.BuildModule.BuildFoundation =
        UnfinishedSudokuModel.BuildModule.BuildFoundation(
            killerSudoku: foundation.killerSudoku,
            elapsedTime: foundation.elapsedTime,
            initialTime: foundation.initialTime,
            isTimerUsed: foundation.isTimerUsed)
        view?.showUnfinishedSudoku(responseFoundation)
    }
}
