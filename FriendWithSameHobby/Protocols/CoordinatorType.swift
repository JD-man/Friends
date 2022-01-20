//
//  CoordinatorType.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit

protocol CoordinateType: AnyObject {
    var childCoordinators: [CoordinateType] { get set }
    var navigationController: UINavigationController { get set }
    
    init(nav: UINavigationController)
    
    func start()    
}
