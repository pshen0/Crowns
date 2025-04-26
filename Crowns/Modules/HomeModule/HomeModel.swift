//
//  Router.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//


enum HomeModel {
    enum RouteToCrownsSettings {
        struct Request { }
        struct Response { }
    }
    
    enum RouteToSudokuSettings {
        struct Request { }
        struct Response { }
    }
    
    enum RouteToQueensSettings {
        struct Request { }
        struct Response { }
    }
    
    enum RouteToCrownsLearning {
        struct Request { }
        struct Response { }
    }
    
    enum RouteToSudokuLearning {
        struct Request { }
        struct Response { }
    }
    
    enum RouteToQueensLearning {
        struct Request { }
        struct Response { }
    }
    
    enum GetUnfinishedCrownsGame {
        struct Request { }
        struct Response { 
            let foundation: CrownsPlayModel.BuildModule.BuildFoundation
        }
        struct ViewModel {
            let foundation: UnfinishedCrownsModel.BuildModule.BuildFoundation
        }
    }
    
    enum GetUnfinishedSudokuGame {
        struct Request { }
        struct Response {
            let foundation: SudokuPlayModel.BuildModule.BuildFoundation
        }
        struct ViewModel {
            let foundation: UnfinishedSudokuModel.BuildModule.BuildFoundation
        }
    }
}
