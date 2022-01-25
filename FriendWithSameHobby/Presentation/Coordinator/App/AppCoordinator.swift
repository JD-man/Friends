//
//  AppCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit

enum StartingCoordinator {
    case auth
    case mainTab
}

final class AppCoordinator: CoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func start() {
        print("App start")
        // switch user auth status
        //addAuthCoordinator()
        addMainTabCoordinator()
    }
    
    func addAuthCoordinator() {
        let authCoordinator = AuthCoordinator(nav: navigationController)
        authCoordinator.parentCoordinator = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func addMainTabCoordinator() {
        let mainTabCoordinator = MainTabCoordinator(nav: navigationController)
        mainTabCoordinator.parentCoordinator = self
        childCoordinators.append(mainTabCoordinator)
        mainTabCoordinator.start()
    }
    
    func completedChild(_ child: CoordinatorType) {
        print(child)
    }
}
