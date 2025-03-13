//
//  MainTabBarModule.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let homeTabBarItem: UITabBarItem = UITabBarItem(title: Text.homeTabBar, image: Images.homeBar, selectedImage: Images.homeBar)
    private let challengeTabBarItem: UITabBarItem = UITabBarItem(title: Text.challengeTabBar, image: Images.challengeBar, selectedImage: Images.challengeBar)
    private let profileTabBarItem: UITabBarItem = UITabBarItem(title: Text.profileTabBar, image: Images.profileBar, selectedImage: Images.profileBar)
    
    
    
    private let homeVC: UIViewController = HomeBuilder.build()
    private let challengeVC: UIViewController = ChallengeBuilder.build()
    private let profileVC: UIViewController = ProfileBuilder.build()
    
    private let homeNavigator: UINavigationController
    private let challengeNavigator: UINavigationController
    private let profileNavigator: UINavigationController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        homeNavigator = UINavigationController(rootViewController: homeVC)
        challengeNavigator = UINavigationController(rootViewController: challengeVC)
        profileNavigator = UINavigationController(rootViewController: profileVC)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Text.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTabBarAppearance()
    }
    
    
    private func changeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.iconColor = Colors.white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Colors.white
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = Colors.yellow
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Colors.yellow
        ]
        
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: Constraints.tabBarItemIndentation)
        
        tabBar.standardAppearance = appearance
    }
    
    private func configureTabBar() {
        
        let homeNavigator = UINavigationController(rootViewController: homeVC)
        let challengeNavigator = UINavigationController(rootViewController: challengeVC)
        let profileNavigator = UINavigationController(rootViewController: profileVC)
        
        homeNavigator.tabBarItem = homeTabBarItem
        challengeNavigator.tabBarItem = challengeTabBarItem
        profileNavigator.tabBarItem = profileTabBarItem
        
        viewControllers = [challengeNavigator, homeNavigator, profileNavigator]
        selectedIndex = Numbers.tabBarSelectedIndex
    }
}
