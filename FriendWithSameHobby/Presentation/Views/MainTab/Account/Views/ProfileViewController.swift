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
    
    var viewModel: ProfileViewModel?
    
    init(profileViewModel: ProfileViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = profileViewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("ProfileVC deinit")
    }
    
    let profileTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = false        
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        $0.register(ProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: ProfileTableViewFooter.identifier)
    }
    
    let footerView = ProfileTableViewFooter()
    
    var testRelay = BehaviorRelay<[Bool]>(value: [false])
    var cellRelay = PublishRelay<ProfileTableViewCell>()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        profileTableViewConfig()
        binding()
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
        
        profileTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func binding() {
        let input = ProfileViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in return () }.asDriver(onErrorJustReturn: ()),
            withdrawTap: footerView.withdrawButton.rx.tap)
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
