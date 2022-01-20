//
//  AuthCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit

final class AuthCoordinator: CoordinateType {
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinators: [CoordinateType] = []
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        let viewModel = OnboardingViewModel()
        viewModel.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
    }
}
