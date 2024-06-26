//
//  MainTabCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class MainTabCoordinator: CoordinatorType {
    deinit {
        print("MainTab deinit")
    }
    weak var parentCoordinator: CoordinatorType? // = AppCoordinator
    weak var finishDelegate: AppCoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorType] = [] // TabView Coordinators
    
    var navigationController: UINavigationController
    var tabbarController: UITabBarController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
        //print("tabbar init nav", navigationController.viewControllers)
        self.tabbarController = UITabBarController()
    }
    
    func start() {
        // 1. Home Coordinator
        let homeNav = tabbarNav(title: "홈", image: AssetsImages.homeIcon.image)
        let homeCoordinator = HomeCoordinator(nav: homeNav)
        coordinatorConfig(coordinator: homeCoordinator)
        
        // 2. Shop Coordinator
        let shopNav = tabbarNav(title: "새싹샵", image: AssetsImages.shopIcon.image)
        let shopCoordinator = ShopCoordinator(nav: shopNav)
        coordinatorConfig(coordinator: shopCoordinator)
        
//        // 3. 새싹친구 탭 삭제
//        let friendsNav = tabbarNav(title: "새싹친구", image: AssetsImages.friendsIcon.image)
//        let friendsCoordinator = FriendsCoordinator(nav: friendsNav)
//        coordinatorConfig(coordinator: friendsCoordinator)
        
        // 3. Account Coordinator
        let accountNav = tabbarNav(title: "내정보", image: AssetsImages.accountIcon.image)
        let accountCoordinator = AccountCoordinator(nav: accountNav)
        coordinatorConfig(coordinator: accountCoordinator)
        
        navigationController.navigationBar.isHidden = true
        
        tabbarController.viewControllers = [homeNav, shopNav, accountNav]        
        navigationController.pushViewController(tabbarController, animated: true)        
    }
    
    private func tabbarNav(title: String, image: UIImage) -> UINavigationController {        
        let nav = UINavigationController()
        let tabbar = UITabBarItem(title: title, image: image, selectedImage: nil)
        nav.tabBarItem = tabbar
        return nav
    }
    
    private func coordinatorConfig(coordinator: CoordinatorType) {
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func finish(to next: AppCordinatorChild, completion: (() -> Void)?) {
        finishDelegate?.didFinish(self, next: next, completion: completion)
    }
}
