//
//  AuthCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//
import UIKit
import Toast

enum AuthBackwardPoint {
    case phoneAuth
    case nickname
}

final class AuthCoordinator: CoordinatorType {
    weak var parentCoordinator: CoordinatorType?    
    weak var finishDelegate: AppCoordinatorFinishDelegate?
    
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func start() {
        pushOnboardingVC()
        //pushPhoneAuthVC()
        //pushNicknameVC()
//        if UserDefaultsManager.onboardingPassed == nil {
//            pushOnboardingVC()
//        }
//        else if UserDefaultsManager.idToken == nil {
//            pushPhoneAuthVC()
//        }
//        else {
//            pushNicknameVC()
//        }
    }
    
    func pushOnboardingVC() {
        let onboardingVC = OnboardingViewController()
        let viewModel = OnboardingViewModel()
        viewModel.coordinator = self
        onboardingVC.viewModel = viewModel
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([onboardingVC], animated: true)
    }
    
    func pushPhoneAuthVC() {
        let pushPhoneAuthVC = PhoneAuthViewController()
        let viewModel = PhoneAuthViewModel()
        viewModel.coordinator = self
        pushPhoneAuthVC.viewModel = viewModel
        navigationController.navigationBar.isHidden = false
        navigationController.setViewControllers([pushPhoneAuthVC], animated: true)
    }
    
    func pushVerifyVC(phoneId: String) {
        let verifyVC = VerifyViewController()
        let viewModel = VerifyViewModel(phoneId: phoneId)
        verifyVC.viewModel = viewModel
        viewModel.coordinator = self
        navigationController.pushViewController(verifyVC, animated: true)
    }
    
    func pushNicknameVC() {
        // coordinator injection
        let viewModel = NickNameViewModel(coordinator: self)
        // viewModel injection
        let nicknameVC = NicknameViewController(viewModel: viewModel)
        navigationController.setViewControllers([nicknameVC], animated: true)
    }
    
    func pushBirthVC() {
        let viewModel = BirthViewModel(coordinator: self)
        let birthVC = BirthViewController(viewModel: viewModel)
        navigationController.pushViewController(birthVC, animated: true)
    }
    
    func pushEmailVC() {
        let viewModel = EmailViewModel(coordinator: self)
        let emailVC = EmailViewController(viewModel: viewModel)
        navigationController.pushViewController(emailVC, animated: true)
    }
    
    func pushRegisterVC() {
        let repository = UserRepository()
        let useCase = RegisterUseCase(userRepository: repository)
        let viewModel = RegisterViewModel(useCase: useCase, coordinator: self)
        let registerVC = RegisterViewController(viewModel: viewModel)
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func finish(to next: AppCordinatorChild, completion: (() -> Void)? ) {
        finishDelegate?.didFinish(self, next: next, completion: completion)
    }
    
    func pop(to point: AuthBackwardPoint, completion: (() -> Void)? ) {
        switch point {
        case .phoneAuth:
            pushPhoneAuthVC()
        case .nickname:
            pushNicknameVC()
        }
        
        guard let completion = completion else { return }
        completion()
    }
    
    func toasting(message: String) {
        navigationController.view.makeToast(message)
    }
}
