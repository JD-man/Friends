//
//  AppCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit

final class AppCoordinator: CoordinateType {
    var childCoordinators: [CoordinateType] = []
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func start() {
        print("App start")
        // switch user auth status
        addAuthCoordinator()
    }
    
    func addAuthCoordinator() {
        let authCoordinator = AuthCoordinator(nav: navigationController)
        authCoordinator.parentCoordinator = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    func completedChild(_ child: CoordinateType) {
        print(child)
    }
}
