//
//  MainTabCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class MainTabCoordinator: CoordinatorType {
    weak var parentCoordinator: CoordinatorType? // = AppCoordinator
    var childCoordinators: [CoordinatorType] = [] // TabView Coordinators
    
    var navigationController: UINavigationController
    var tabbarController: UITabBarController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
        self.tabbarController = UITabBarController()
    }
    
    func start() {
        let homeVC = HomeViewController()
        let shopVC = ShopViewController()
        let accountVC = AccountViewController()
        let friendsVC = FriendsViewController()
        
        let homeItem = UITabBarItem(title: "홈", image: nil, selectedImage: nil)
        let shopItem = UITabBarItem(title: "새싹샵", image: nil, selectedImage: nil)
        let accountItem = UITabBarItem(title: "내정보", image: nil, selectedImage: nil)
        let friendsItem = UITabBarItem(title: "새싹친구", image: nil, selectedImage: nil)
        
        homeVC.tabBarItem = homeItem
        shopVC.tabBarItem = shopItem
        accountVC.tabBarItem = accountItem
        friendsVC.tabBarItem = friendsItem
        
        navigationController.navigationBar.isHidden = true
        tabbarController.viewControllers = [homeVC, shopVC, accountVC,friendsVC]
        navigationController.pushViewController(tabbarController, animated: true)
    }
}
