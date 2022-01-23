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
        onboardingVC.viewModel = viewModel
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func pushPhoneAuthVC() {
        let pushPhoneAuthVC = PhoneAuthViewController()
        let viewModel = PhoneAuthViewModel()
        viewModel.coordinator = self
        pushPhoneAuthVC.viewModel = viewModel
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(pushPhoneAuthVC, animated: true)
    }
    
    func pushVerifyVC(phoneId: String) {
        let verifyVC = VerifyViewController()
        let viewModel = VerifyViewModel(phoneId: phoneId)
        viewModel.coordinator = self
        verifyVC.viewModel = viewModel
        navigationController.pushViewController(verifyVC, animated: true)
    }
}
