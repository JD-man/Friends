//
//  AccountCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class AccountCoordinator: CoordinatorType {
    
    weak var parentCoordinator: CoordinatorType?
    
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
        let repository = UserRepository()
        let useCase = ProfileUseCase(userRepo: repository)
        let viewModel = ProfileViewModel(useCase: useCase, coordinator: self)
        let profileVC = ProfileViewController(profileViewModel: viewModel)
        navigationController.pushViewController(profileVC, animated: true)
    }
}
