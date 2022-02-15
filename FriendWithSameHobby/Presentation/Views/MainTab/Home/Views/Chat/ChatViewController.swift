//
//  ChatViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxKeyboard
import RxGesture
import RxRelay

class ChatViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let chatTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemBackground
        $0.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        $0.register(ChatTableHeaderView.self, forHeaderFooterViewReuseIdentifier: ChatTableHeaderView.identifier)
    }
    private let messageTextView = UITextView().then {
        $0.addCorner(rad: 8, borderColor: nil)
        $0.backgroundColor = AssetsColors.gray1.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    let testRelay = BehaviorRelay<[ChatItemViewModel]>(value: [
        ChatItemViewModel(userType: .me, message: "나", time: "11:11"),
        ChatItemViewModel(userType: .you, message: "너", time: "22:22"),
        ChatItemViewModel(userType: .you, message: "너", time: "33:33"),
        ChatItemViewModel(userType: .you, message: "너", time: "44:44"),
        ChatItemViewModel(userType: .me, message: "나", time: "55:55"),
        ChatItemViewModel(userType: .you, message: "너", time: "66:66"),
        ChatItemViewModel(userType: .me, message: "나", time: "77:77"),
        ChatItemViewModel(userType: .you, message: "너", time: "88:88")
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [chatTableView, messageTextView].forEach { view.addSubview($0) }
        
        messageTextView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(52)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(messageTextView.snp.top).offset(-16)
        }
        
        chatTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func binding() {
        testRelay
            .asDriver()
            .drive(chatTableView.rx.items(
                cellIdentifier: ChatTableViewCell.identifier,
                cellType: ChatTableViewCell.self)) { row, item, cell in
                    cell.configure(with: item)
                }.disposed(by: disposeBag)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatTableHeaderView.identifier) as? ChatTableHeaderView else {
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}
