//
//  MainTabBarModule.swift
//  Crowns
//
//  Created by Анна Сазонова on 28.01.2025.
//

import UIKit

// MARK: - MainTabBarController class
final class MainTabBarController: UITabBarController {
    // MARK: - Properties
    private let homeTabBarItem: UITabBarItem = UITabBarItem(title: Constants.homeTab, image: UIImage.homeBar, selectedImage: UIImage.homeBar)
    private let challengeTabBarItem: UITabBarItem = UITabBarItem(title: Constants.challengeTab, image: UIImage.challengeBar, selectedImage: UIImage.challengeBar)
    private let profileTabBarItem: UITabBarItem = UITabBarItem(title: Constants.profileTab, image: UIImage.profileBar, selectedImage: UIImage.profileBar)
    
    private let homeVC: UIViewController = HomeBuilder.build()
    private let challengeVC: UIViewController = ChallengeBuilder.build()
    private let profileVC: UIViewController = ProfileBuilder.build()
    
    private let homeNavigator: UINavigationController
    private let challengeNavigator: UINavigationController
    private let profileNavigator: UINavigationController
    
    // MARK: - Lifecycle
    init() {
        homeNavigator = UINavigationController(rootViewController: homeVC)
        challengeNavigator = UINavigationController(rootViewController: challengeVC)
        profileNavigator = UINavigationController(rootViewController: profileVC)
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Errors.initErrorCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTabBarAppearance()
    }
    
    // MARK: - Private funcs
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
        
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: Constants.tabBarItemIndentation)
        
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
        selectedIndex = Constants.selectedIndex
    }
    
    // MARK: - Constants
    private enum Constants {
        static let homeTab: String = "Home"
        static let challengeTab: String = "Challenges"
        static let profileTab: String = "Profile"
        
        static let selectedIndex: Int = 1
        static let tabBarItemIndentation: CGFloat = 10
    }
}
