//
//  AccountCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit

final class AccountCoordinator: CoordinatorType {
    deinit {
        print("Account coordinator deinit")
    }
    
    weak var parentCoordinator: CoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        // new navi
        self.navigationController = nav
    }
    
    func start() {
        // Start with accountVC
        let accountVC = AccountViewController(coordinator: self)
        navigationController.pushViewController(accountVC, animated: true)        
    }
    
    func pushProfileVC() {
        let userRepo = UserRepository()
        let phoneAuthRepo = FirebaseAuthRepository(phoneID: nil)
        let useCase = ProfileUseCase(phoneAuthRepo: phoneAuthRepo, userRepo: userRepo)
        let viewModel = ProfileViewModel(useCase: useCase, coordinator: self)
        let profileVC = ProfileViewController(profileViewModel: viewModel)
        profileVC.hidesBottomBarWhenPushed = true        
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func pushCommentVC(review: [String]) {
        let commentVC = CommentViewController(review: review)
        commentVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(commentVC, animated: true)
    }
    
    func pop(completion: (() -> Void)? ) {
        navigationController.popViewController(animated: true)
        guard let completion = completion else { return }
        completion()
    }
    
    func toasting(message: String) {
        navigationController.view.makeToast(message)
    }
}
