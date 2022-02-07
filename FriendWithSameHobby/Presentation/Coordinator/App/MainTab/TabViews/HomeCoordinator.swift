//
//  HomeCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class HomeCoordinator: CoordinatorType {
    weak var parentCoordinator: CoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        // new navi
        self.navigationController = nav
    }
    
    func start() {
        // Start with accountVC
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let useCase = HomeUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = HomeViewModel(useCase: useCase, coordinator: self)
        let homeVC = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func pushHobbyVC(lat: Double, long: Double) {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let useCase = HomeUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = HobbyViewModel(useCase: useCase, coordinator: self, lat: lat, long: long)
        let hobbyVC = HobbyViewController(viewModel: viewModel)
        navigationController.pushViewController(hobbyVC, animated: true)
    }
}
