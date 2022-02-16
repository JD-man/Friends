//
//  ChatMenuViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture

class ChatMenuViewController: UIViewController {
    deinit {
        print("ChatMenuVC deinit")
    }
    
    enum AnimationType {
        case present
        case dismiss
        
        var constant: CGFloat {
            switch self {
            case .present:
                return 0
            case .dismiss:
                return -72
            }
        }
    }

    private let reportButton = MenuButton(title: "새싹 신고", image: AssetsImages.siren.image)
    private let dodgeButton = MenuButton(title: "약속 취소", image: AssetsImages.cancelMatch.image)
    private let reviewButton = MenuButton(title: "리뷰 등록", image: AssetsImages.write.image)
    
    private let viewModel: ChatMenuViewModel
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [reportButton, dodgeButton, reviewButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    private var disposeBag = DisposeBag()
    
    init(viewModel: ChatMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialAnimation(type: .present)
    }
    
    private func viewConfig() {
        view.backgroundColor = AssetsColors.black.color.withAlphaComponent(0.25)
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-72)
        }
    }
    
    private func binding() {
        let input = ChatMenuViewModel.Input(
            dodgeButtonTap: dodgeButton.rx.tap.asDriver()
        )
        
        let output = viewModel
        
        reportButton.rx.tap
            .asDriver()
            .drive { _ in
                print("reportButton")
            }.disposed(by: disposeBag)
        
        reviewButton.rx.tap
            .asDriver()
            .drive { _ in
                print("reviewButton")
            }.disposed(by: disposeBag)
        
        view.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.initialAnimation(type: .dismiss)
            }).disposed(by: disposeBag)
    }
    
    private func initialAnimation(type: AnimationType) {
        buttonStackView.snp.updateConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(type.constant)
        }
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            if type == .dismiss {
                self?.view.removeFromSuperview()
                self?.didMove(toParent: nil)
                self?.removeFromParent()
            }
        }
        animator.startAnimation()
    }
}
