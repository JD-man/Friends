//
//  AccountViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

struct AccountCellModel {
    let iconImage: UIImage
    let titleText: String
}

class AccountViewController: UIViewController {
    
    weak var coordinator: AccountCoordinator?
    
    private let cellModels: [AccountCellModel] = [
        AccountCellModel(iconImage: AssetsImages.notice.image, titleText: "공지사항"),
        AccountCellModel(iconImage: AssetsImages.faq.image, titleText: "자주 묻는 질문"),
        AccountCellModel(iconImage: AssetsImages.qna.image, titleText: "1:1 문의"),
        AccountCellModel(iconImage: AssetsImages.settingAlarm.image, titleText: "알림 설정"),
        AccountCellModel(iconImage: AssetsImages.permit.image, titleText: "이용 약관"),
    ]
    
    private var disposeBag = DisposeBag()
    private let accountCellRelay = BehaviorRelay<[AccountCellModel]>(value: [])
    private let accountHeaderView = AccountTableHeaderView()
    
    private var accountTableView = UITableView().then {
        $0.rowHeight = 74
        $0.register(AccountTableHeaderView.self, forHeaderFooterViewReuseIdentifier: AccountTableHeaderView.identifier)
        $0.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.identifier)
    }
    
    init(coordinator: AccountCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
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
        title = "내정보"
        view.backgroundColor = .systemBackground
        view.addSubview(accountTableView)
        accountTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        accountCellRelay.accept(cellModels)
    }
    
    private func binding() {
        accountCellRelay
            .asDriver()
            .drive(accountTableView.rx.items(cellIdentifier: AccountTableViewCell.identifier, cellType: AccountTableViewCell.self)) { row, model, cell in
                cell.configure(with: model)
            }.disposed(by: disposeBag)
        
        accountHeaderView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushProfileVC()
            }).disposed(by: disposeBag)
        
        accountTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return accountHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 96
    }
}
