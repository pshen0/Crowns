//
//  ProfileRouter.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

enum ProfileModel {
    enum RouteSettings {
        struct Request { }
        struct Response { }
    }
    
    enum RouteStatistics {
        struct Request { }
        struct Response { }
    }
    
    enum RouteDeveloper {
        struct Request { }
        struct Response { }
    }
    
    enum LoadProfile {
        struct Request { }
        struct Response { 
            let name: String
            let avatar: UIImage
        }
        struct ViewModel { 
            let name: String
            let avatar: UIImage
        }
    }
    
    enum SaveProfile {
        struct Request {
            let name: String?
            let avatar: UIImage?
        }
    }
}
