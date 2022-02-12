//
//  HomeCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import Toast

enum HomeCoordinatorViews {
    case mapView
    case hobbyView(lat: Double, long: Double)
    case matchingView(lat: Double, long: Double)
}

enum HomeCoordinatorShowStyle {
    case push
    case backToFirst
}

final class HomeCoordinator: CoordinatorType {
    weak var parentCoordinator: CoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        // new navi
        self.navigationController = nav
    }
    
    func start() {
        show(view: .mapView, by: .push)
    }
    
    private func mapVC() -> MapViewController {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let useCase = MapUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = MapViewModel(useCase: useCase, coordinator: self)
        let mapVC = MapViewController(viewModel: viewModel)
        mapVC.hidesBottomBarWhenPushed = false
        return mapVC
    }
    
    private func hobbyVC(lat: Double, long: Double) -> HobbyViewController {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let useCase = HobbyUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = HobbyViewModel(useCase: useCase, coordinator: self, lat: lat, long: long)
        let hobbyVC = HobbyViewController(viewModel: viewModel)
        hobbyVC.hidesBottomBarWhenPushed = true
        return hobbyVC
    }
    
    private func matchingVC(lat: Double, long: Double) -> MatchingViewController {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let useCase = MatchingUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = MatchingViewModel(useCase: useCase, coordinator: self, lat: lat, long: long)
        let matchingVC = MatchingViewController(viewModel: viewModel)
        matchingVC.hidesBottomBarWhenPushed = true
        return matchingVC
    }
    
    func toasting(message: String) {
        navigationController.view.makeToast(message, position: .top)
    }
    
    func show(view: HomeCoordinatorViews, by: HomeCoordinatorShowStyle) {
        switch view {
        case .mapView:
            showBy(view: mapVC(), style: by)
        case .hobbyView(let lat, let long):
            showBy(view: hobbyVC(lat: lat, long: long), style: by)
        case .matchingView(let lat, let long):
            showBy(view: matchingVC(lat: lat, long: long), style: by)
        }
    }
    
    private func showBy(view: UIViewController, style: HomeCoordinatorShowStyle) {
        switch style {
        case .push:
            navigationController.pushViewController(view, animated: true)
        case .backToFirst:
            navigationController.setViewControllers([view], animated: true)
        }
    }
}
