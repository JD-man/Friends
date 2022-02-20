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
        let useCase = ShopUseCase()
        let viewModel = ShopViewModel(useCase: useCase, coordinator: self)
        let shopVC = ShopViewController(viewModel: viewModel)
        navigationController.pushViewController(shopVC, animated: true)
    }
}
