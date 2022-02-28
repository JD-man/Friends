//
//  CoordinatorType.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit

protocol CoordinatorType: AnyObject {
    var parentCoordinator: CoordinatorType? { get set }
    var childCoordinators: [CoordinatorType] { get set }
    var navigationController: UINavigationController { get set }
    
    init(nav: UINavigationController)
    
    func start()    
}
