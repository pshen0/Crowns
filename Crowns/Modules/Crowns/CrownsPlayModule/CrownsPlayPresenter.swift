//
//  CrownsPlayPresenter.swift
//  Crowns
//
//  Created by Анна Сазонова on 03.02.2025.
//

import UIKit

protocol CrownsPlayPresentationLogic {
    func roureBack(_ response: CrownsPlayModel.RouteBack.Response)
    func routeGameOver(_ response: CrownsPlayModel.RouteGameOver.Response)
    func presentTime (_ response: CrownsPlayModel.SetTime.Response)
    func showHint(_ response: CrownsPlayModel.GetHint.Response)
    func showUndoMove(_ response: CrownsPlayModel.UndoMove.Response)
    func setLevelImage(_ response: CrownsPlayModel.GetLevel.Response)
}

final class CrownsPlayPresenter: CrownsPlayPresentationLogic {
    
    weak var view: CrownsPlayViewController?
    
    func roureBack(_ response: CrownsPlayModel.RouteBack.Response) {
        view?.navigationController?.popToRootViewController(animated: false)
    }
    
    func routeGameOver(_ response: CrownsPlayModel.RouteGameOver.Response) {
        view?.navigationController?.pushViewController(CrownsGameOverBuilder.build(isWin: response.isWin, time: getStringTime(response.time)), animated: false)
    }
    
    private func getStringTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        let minutesStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsStr = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let timerLabel = minutesStr + ":" + secondsStr
        return timerLabel
    }
    
    func presentTime(_ response: CrownsPlayModel.SetTime.Response) {
        view?.setTimerLabel(CrownsPlayModel.SetTime.ViewModel(timerLabel: getStringTime(response.time)))
    }
    
    func showHint(_ response: CrownsPlayModel.GetHint.Response) {
        let indexPath = IndexPath(item: response.row * 9 + response.col, section: 0)
        view?.updateCrownsPlayground(CrownsPlayModel.UpdateCrownsPlayground.ViewModel(indexPath: indexPath, color: response.color, mode: "hint", value: 2))
    }
    
    func showUndoMove(_ response: CrownsPlayModel.UndoMove.Response) {
        view?.updateCrownsPlayground(CrownsPlayModel.UpdateCrownsPlayground.ViewModel(indexPath: response.move.indexPath, color: response.color, mode: "undo", value: response.move.value))
    }
    
    func setLevelImage(_ response: CrownsPlayModel.GetLevel.Response) {
        view?.setLevelPicture(CrownsPlayModel.GetLevel.ViewModel(image: response.image))
    }
}
