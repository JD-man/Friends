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
    func didFinish(_ coordinator: CoordinatorType, next: AppCordinatorChild, completion: (() -> Void)?)
}

final class AppCoordinator: NSObject, CoordinatorType {
    var parentCoordinator: CoordinatorType? = nil
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func start() {
        print("App start")
        
        if UserProgressManager.registered == nil {
            addAuthCoordinator()
        }
        else {
            addMainTabCoordinator()
        }
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
    func didFinish(_ coordinator: CoordinatorType, next: AppCordinatorChild, completion: (() -> Void)?) {
        childCoordinators = childCoordinators.filter { !($0 === coordinator) }
        switch next {
        case .auth:
            addAuthCoordinator()
        case .mainTab:
            addMainTabCoordinator()
        }
        var navArr = navigationController.viewControllers
        let last = navArr.last
        navArr.removeAll()
        navArr.append(last!)
        navigationController.viewControllers = navArr
        if last! is UITabBarController {
            print("tab")
        }
        else {
            print("not tab")
        }
        
        guard let completion = completion else { return }
        completion()
    }
}
