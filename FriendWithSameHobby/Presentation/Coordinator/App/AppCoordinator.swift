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
    func didFinish(_ coordinator: CoordinatorType, next: AppCordinatorChild, completion: @escaping () -> Void)
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
    func didFinish(_ coordinator: CoordinatorType, next: AppCordinatorChild, completion: @escaping () -> Void) {
        childCoordinators = childCoordinators.filter { !($0 === coordinator) }
        switch next {
        case .auth:
            addAuthCoordinator()
        case .mainTab:
            addMainTabCoordinator()
        }
        
        var navArr = navigationController.viewControllers
        print("===============================================")
        print("before removing navArr: ", navArr)
        let last = navArr.last
        print("===============================================")
        print("lastVC: ", last)
        navArr.removeAll()
        navArr.append(last!)
        
        print("===============================================")
        print("after removing navArr: ", navArr)
        
        navigationController.viewControllers = navArr
        
        print("===============================================")
        print("after embedding: ", navArr)
        print("===============================================")
        
        if last! is UITabBarController {
            print("tab")
        }
        else {
            print("not tab")
        }
        //last!.view.backgroundColor = .red
        completion()
        
    }
}
