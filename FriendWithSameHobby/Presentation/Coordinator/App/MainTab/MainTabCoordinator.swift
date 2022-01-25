//
//  MainTabCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class MainTabCoordinator {
    weak var parentCoordinator: CoordinateType? // = AppCoordinator
    var childCoordinators: [CoordinateType] = [] // TabView Coordinators
    
    var tabbarController: UITabBarController
    
    init(tab: UITabBarController) {
        self.tabbarController = tab
    }
    
    func start() {
        configHomeVC()
        configShopVC()
        configFriendsVC()
        configAccountVC()
    }
    
    func configHomeVC() {
        // repo, usecase, vm needed
        let homeVC = HomeViewController()
        
    }
    
    func configShopVC() {
        
    }
    
    func configFriendsVC() {
        
    }
    
    func configAccountVC() {
        
    }
}
