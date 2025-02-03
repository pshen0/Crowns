//
//  File.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import Foundation

protocol ProfileInteractorProtocol: AnyObject {
    
}

class ProfileInteractor: ProfileInteractorProtocol {
    weak var presenter: ProfilePresenterProtocol?

}
