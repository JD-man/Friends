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
        //pushOnboardingVC()
        //pushPhoneAuthVC()
        //pushNicknameVC()
        if UserProgressManager.onboardingPassed == nil {
            pushOnboardingVC()
        }
        else if UserProgressManager.loggedIn == nil {
            print(UserProgressManager.loggedIn)
            pushPhoneAuthVC()
        }
        else {
            pushNicknameVC()
        }
    }
    
    func pushOnboardingVC() {
        let onboardingVC = OnboardingViewController()
        let useCase = OnboardingUseCase()
        let viewModel = OnboardingViewModel(useCase: useCase, coordinator: self)
        viewModel.coordinator = self
        onboardingVC.viewModel = viewModel
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([onboardingVC], animated: true)
    }
    
    func pushPhoneAuthVC() {
        let pushPhoneAuthVC = PhoneAuthViewController()
        let phoneAuthRepo = FirebaseAuthRepository(phoneID: nil)
        let useCase = PhoneAuthUseCase(phoneAuthRepo: phoneAuthRepo)
        let viewModel = PhoneAuthViewModel(useCase: useCase, coordinator: self)
        viewModel.coordinator = self
        pushPhoneAuthVC.viewModel = viewModel
        navigationController.navigationBar.isHidden = false
        navigationController.setViewControllers([pushPhoneAuthVC], animated: true)
    }
    
    func pushVerifyVC(phoneId: String) {
        let verifyVC = VerifyViewController()
        let phoneAuthRepo = FirebaseAuthRepository(phoneID: phoneId)
        let userRepo = UserRepository()
        let useCase = VerifyUseCase(userRepo: userRepo, phoneAuthRepo: phoneAuthRepo)
        let viewModel = VerifyViewModel(useCase: useCase, coordinator: self)
        verifyVC.viewModel = viewModel
        viewModel.coordinator = self
        navigationController.pushViewController(verifyVC, animated: true)
    }
    
    func pushNicknameVC() {        
        let viewModel = NickNameViewModel(useCase: nil, coordinator: self)
        let nicknameVC = NicknameViewController(viewModel: viewModel)
        navigationController.setViewControllers([nicknameVC], animated: true)
    }
    
    func pushBirthVC() {
        let viewModel = BirthViewModel(useCase: nil, coordinator: self)
        let birthVC = BirthViewController(viewModel: viewModel)
        navigationController.pushViewController(birthVC, animated: true)
    }
    
    func pushEmailVC() {
        let viewModel = EmailViewModel(useCase: nil, coordinator: self)
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
