//
//  HobbyViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//
import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import RxKeyboard
import RxGesture

final class HobbyViewController: UIViewController {
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "띄어쓰기로 복수 입력이 가능해요"
    }
    private let findButton = BaseButton(title: "새싹 찾기", status: .fill, type: .h48)
        
    private var viewModel: HobbyViewModel?
    private var disposeBag = DisposeBag()
    
    init(viewModel: HobbyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        view.addSubview(findButton)
        findButton.snp.makeConstraints { make in
            make.height.equalTo(findButton.frame.height)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        // search bar config
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func binding() {
        // MARK: - Keyboard handling
        RxKeyboard.instance.willShowVisibleHeight
            .drive { [weak self] in
                let safeAreaBottom = self?.view.safeAreaInsets.bottom ?? 0
                self?.keyboardHandling(of: .show(height: $0, safeAreaBottom: safeAreaBottom))
            }.disposed(by: disposeBag)
        
        view.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
                self?.keyboardHandling(of: .hide)
            }).disposed(by: disposeBag)
    }
    
    private func keyboardHandling(of status: KeyboardStatus) {
        findButton.snp.updateConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(status.sideInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16 + status.height - status.safeAreaBottom)
        }
        findButton.addCorner(rad: status.cornerRadius, borderColor: nil)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

enum KeyboardStatus {
    case show(height: CGFloat, safeAreaBottom: CGFloat)
    case hide
    
    var height: CGFloat {
        switch self {
        case .show(let height, _):
            return height - 16
        case .hide:
            return 0
        }
    }
    
    var safeAreaBottom: CGFloat {
        switch self {
        case .show(_, let safeAreaBottom):
            return safeAreaBottom
        case .hide:
            return 0
        }
    }
    
    var sideInset: CGFloat {
        switch self {
        case .show:
            return 0
        case .hide:
            return 16
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .show:
            return 0
        case .hide:
            return 8
        }
    }
}
