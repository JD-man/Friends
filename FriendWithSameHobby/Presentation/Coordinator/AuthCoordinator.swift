//
//  AuthCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit

final class AuthCoordinator: CoordinateType {
    var childNavigation: [CoordinateType]?
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    func start() {
        print("Auth Coordinator Start")
    }
}
