//
//  ProfileViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    deinit {
        print("ProfileVC deinit")
    }
    
    let profileTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false        
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
    }
    
    var testRelay = BehaviorRelay<[Bool]>(value: [
        false, false, false, false, false,        
    ])
    var cellRelay = PublishRelay<ProfileTableViewCell>()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        profileTableViewConfig()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileTableView)
        profileTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func profileTableViewConfig() {
        testRelay
            .asDriver()
            .drive(profileTableView.rx.items(
                cellIdentifier: ProfileTableViewCell.identifier,
                cellType: ProfileTableViewCell.self)) { [weak self] row, item, cell in
                    cell.expand(item)
                    cell.baseCardView.moreButton.rx.tap
                        .asDriver()
                        .drive { [weak self] _ in
                            guard let strongSelf = self else { return }
                            var value = strongSelf.testRelay.value
                            value[row] = !value[row]
                            strongSelf.testRelay.accept(value)
                        }.disposed(by: cell.disposeBag)
                }.disposed(by: disposeBag)
    }
}
