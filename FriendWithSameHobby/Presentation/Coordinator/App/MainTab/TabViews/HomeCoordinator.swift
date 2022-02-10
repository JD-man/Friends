//
//  HomeCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import Toast

final class HomeCoordinator: CoordinatorType {
    weak var parentCoordinator: CoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        // new navi
        self.navigationController = nav
    }
    
    func start() {
        pushHomeVC()        
    }
    
    func pushHomeVC() {
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
        let useCase = HobbyUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = HobbyViewModel(useCase: useCase, coordinator: self, lat: lat, long: long)
        let hobbyVC = HobbyViewController(viewModel: viewModel)
        hobbyVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(hobbyVC, animated: true)
    }
    
    func pushMatchingVC(lat: Double, long: Double) {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let useCase = MatchingUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = MatchingViewModel(useCase: useCase, coordinator: self, lat: lat, long: long)
        let userSearchVC = MatchingViewController(viewModel: viewModel)
        userSearchVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(userSearchVC, animated: true)
    }
    
    func toasting(message: String) {
        navigationController.view.makeToast(message, position: .top)
    }
}
