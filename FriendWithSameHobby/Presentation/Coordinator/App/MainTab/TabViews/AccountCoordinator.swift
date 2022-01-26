//
//  AccountCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class AccountCoordinator: CoordinatorType {
    
    weak var parentCoordinator: MainTabCoordinator?
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        // new navi
        self.navigationController = nav
    }
    
    func start() {
        // Start with accountVC
        let accountVC = AccountViewController(coordinator: self)
        navigationController.pushViewController(accountVC, animated: true)        
    }
    
    func pushProfileVC() {
        let profileVC = ProfileViewController()
        navigationController.pushViewController(profileVC, animated: true)
    }
}
