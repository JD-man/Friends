//
//  ShopCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class ShopCoordinator: CoordinatorType {
    weak var parentCoordinator: CoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        // new navi
        self.navigationController = nav
    }
    
    func start() {
        pushShopVC()
    }
    
    func pushShopVC() {
        let userRepo = UserRepository()
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let useCase = ShopUseCase(userRepo: userRepo, firebaseRepo: firebaseRepo)
        let viewModel = ShopViewModel(useCase: useCase, coordinator: self)
        let shopVC = ShopViewController(viewModel: viewModel)
        navigationController.pushViewController(shopVC, animated: true)
    }
    
    func toasting(message: String) {
        navigationController.view.makeToast(message, position: .top)
    }
}
