//
//  HomeCoordinator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import Toast

enum HomeCoordinatorViews {
    case mapView
    case hobbyView(lat: Double, long: Double)
    case matchingView(lat: Double, long: Double)
    case chatView
    case commentView(review: [String])
    case profileView
}

enum HomeCoordinatorShowStyle {
    case push
    case backToFirst
}

final class HomeCoordinator: CoordinatorType {
    weak var parentCoordinator: CoordinatorType?
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        // new navi
        self.navigationController = nav
    }
    
    func start() {
        show(view: .mapView, by: .push)
        //show(view: .chatView, by: .push)
    }
    
    private func mapVC() -> MapViewController {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let userRepo = UserRepository()
        let useCase = MapUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo, userRepo: userRepo)
        let viewModel = MapViewModel(useCase: useCase, coordinator: self)
        let mapVC = MapViewController(viewModel: viewModel)
        mapVC.hidesBottomBarWhenPushed = false
        return mapVC
    }
    
    private func hobbyVC(lat: Double, long: Double) -> HobbyViewController {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let userRepo = UserRepository()
        let useCase = HobbyUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo, userRepo: userRepo)
        let viewModel = HobbyViewModel(useCase: useCase, coordinator: self, lat: lat, long: long)
        let hobbyVC = HobbyViewController(viewModel: viewModel)
        hobbyVC.hidesBottomBarWhenPushed = true
        return hobbyVC
    }
    
    private func matchingVC(lat: Double, long: Double) -> MatchingViewController {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let userRepo = UserRepository()
        let useCase = MatchingUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo, userRepo: userRepo)
        let viewModel = MatchingViewModel(useCase: useCase, coordinator: self, lat: lat, long: long)
        let matchingVC = MatchingViewController(viewModel: viewModel)
        matchingVC.hidesBottomBarWhenPushed = true
        return matchingVC
    }
    
    private func commentVC(review: [String]) -> CommentViewController {
        let commentVC = CommentViewController(review: review)
        commentVC.hidesBottomBarWhenPushed = true
        return commentVC
    }
    
    private func chatVC() -> ChatViewController {
        let chatRepo = ChatRepository()
        let queueRepo = QueueRepository()
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let realmRepo = RealmRepository()
        let useCase = ChatUseCase(
            firebaseRepo: firebaseRepo,
            queueRepo: queueRepo,
            chatRepo: chatRepo,
            realmRepo: realmRepo)
        let viewModel = ChatViewModel(useCase: useCase, coordinator: self)
        let chatVC = ChatViewController(viewModel: viewModel)
        chatVC.hidesBottomBarWhenPushed = true
        return chatVC
    }
    
    func profileVC() -> ProfileViewController {
        let userRepo = UserRepository()
        let phoneAuthRepo = FirebaseAuthRepository(phoneID: nil)
        let useCase = ProfileUseCase(phoneAuthRepo: phoneAuthRepo, userRepo: userRepo)
        let viewModel = ProfileViewModel(useCase: useCase, coordinator: nil)
        let profileVC = ProfileViewController(profileViewModel: viewModel)
        profileVC.hidesBottomBarWhenPushed = true
        return profileVC
    }
    
    func presentChatMenuVC() {
        guard let chatVC = navigationController.topViewController as? ChatViewController else { return }
        guard let menuVC = chatVC.children.first as? ChatMenuViewController else {
            let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
            let userRepo = UserRepository()
            let queueRepo = QueueRepository()
            let useCase = ChatMenuUseCase(firebaseRepo: firebaseRepo, userRepo: userRepo, queueRepo: queueRepo)
            let viewModel = ChatMenuViewModel(useCase: useCase, coordinator: self)
            let chatMenuVC = ChatMenuViewController(viewModel: viewModel)
            chatVC.addChild(chatMenuVC)
            chatVC.view.addSubview(chatMenuVC.view)
            chatMenuVC.didMove(toParent: chatVC)
            return
        }
        menuVC.initialAnimation(type: .present)
    }
    
    func presentCommentVC() {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let queueRepo = QueueRepository()
        let useCase = MenuCommentUseCase(firebaseRepo: firebaseRepo, queueRepo: queueRepo)
        let viewModel = MenuCommentViewModel(useCase: useCase, coordinator: self)
        let commentVC = MenuCommentViewController(viewModel: viewModel)
        commentVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(commentVC, animated: false)
    }
    
    func presentReportVC() {
        let firebaseRepo = FirebaseAuthRepository(phoneID: nil)
        let userRepo = UserRepository()
        let useCase = MenuReportUseCase(firebaseRepo: firebaseRepo, userRepo: userRepo)
        let viewModel = MenuReportViewModel(useCase: useCase, coordinator: self)
        let reportVC = MenuReportViewController(viewModel: viewModel)
        reportVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(reportVC, animated: false)
    }
    
    func toasting(message: String) {
        navigationController.view.makeToast(message, position: .top)
    }
    
    func show(view: HomeCoordinatorViews, by: HomeCoordinatorShowStyle) {
        switch view {
        case .mapView:
            showBy(view: mapVC(), by: by)
        case .hobbyView(let lat, let long):
            showBy(view: hobbyVC(lat: lat, long: long), by: by)
        case .matchingView(let lat, let long):
            showBy(view: matchingVC(lat: lat, long: long), by: by)
        case .chatView:
            showBy(view: chatVC(), by: by)
        case .commentView(let review):
            showBy(view: commentVC(review: review), by: by)
        case .profileView:
            showBy(view: profileVC(), by: by)
        }
    }
    
    private func showBy(view: UIViewController, by style: HomeCoordinatorShowStyle) {
        switch style {
        case .push:            
            navigationController.pushViewController(view, animated: true)
        case .backToFirst:
            navigationController.viewControllers.insert(view, at: 0)
            //navigationController.setViewControllers([view], animated: true)
            navigationController.popToRootViewController(animated: true)
        }
    }
}
