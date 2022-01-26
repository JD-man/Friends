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
        tabbarConfig()
        // 1. Home Coordinator
        // 2. Shop Coordinator
        // 3. Friends Coordinator
        
        // 4. Account Coordinator
        let accountNav = accountCoordinatorConfig()
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(tabbarController, animated: true)
        tabbarController.viewControllers = [accountNav]
    }
    
    private func accountCoordinatorConfig() -> UINavigationController {
        // config nav
        let accountNav = UINavigationController()
        let accountTabbar = UITabBarItem(title: "내정보", image: AssetsImages.accountIcon.image, selectedImage: nil)
        accountNav.tabBarItem = accountTabbar
        
        // config coordinator
        let accountCoordinator = AccountCoordinator(nav: accountNav)
        accountCoordinator.parentCoordinator = self
        childCoordinators.append(accountCoordinator)
        accountCoordinator.start()
        return accountNav
    }
    
    private func tabbarConfig() {
        if #available(iOS 15.0, *) {
            let tabbarAppearance = UITabBarAppearance()
            tabbarAppearance.configureWithOpaqueBackground()
            tabbarAppearance.backgroundColor = .systemBackground
            
            let tabbarItemAppearance = UITabBarItemAppearance()
            tabbarItemAppearance.normal.titleTextAttributes = [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)]
            tabbarItemAppearance.selected.titleTextAttributes = [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)]
            
            UITabBar.appearance().standardAppearance = tabbarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabbarAppearance
            tabbarAppearance.stackedLayoutAppearance = tabbarItemAppearance            
        }
        else {
            UITabBar.appearance().barTintColor = .systemBackground
        }
        
        UITabBar.appearance().tintColor = AssetsColors.green.color
        UITabBar.appearance().unselectedItemTintColor = AssetsColors.gray6.color
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)], for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font : AssetsFonts.NotoSansKR.regular.font(size: 12)], for: .selected
        )
    }
}
