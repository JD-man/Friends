//
//  AppCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit

enum AppCordinatorChild {
    case auth
    case mainTab
}

protocol AppCoordinatorFinishDelegate: AnyObject {
    func didFinish(_ coordinator: CoordinatorType, next: AppCordinatorChild)
}

final class AppCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType? = nil
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func start() {
        print("App start")
        // switch user auth status
        addAuthCoordinator()
        //addMainTabCoordinator()
    }
    
    func addAuthCoordinator() {
        let authCoordinator = AuthCoordinator(nav: navigationController)
        authCoordinator.parentCoordinator = self
        authCoordinator.finishDelegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func addMainTabCoordinator() {
        let mainTabCoordinator = MainTabCoordinator(nav: navigationController)
        mainTabCoordinator.parentCoordinator = self
        mainTabCoordinator.finishDelegate = self
        childCoordinators.append(mainTabCoordinator)
        mainTabCoordinator.start()
    }
    
    func completedChild(_ child: CoordinatorType) {
        print(child)
    }
}

extension AppCoordinator: AppCoordinatorFinishDelegate {
    func didFinish(_ coordinator: CoordinatorType, next: AppCordinatorChild) {
        childCoordinators = childCoordinators.filter { !($0 === coordinator) }
        navigationController.viewControllers.removeAll()
        
        switch next {
        case .auth:
            addAuthCoordinator()
        case .mainTab:
            addMainTabCoordinator()
        }
    }
}
