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
    private let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let chatTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemBackground
        $0.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        $0.register(ChatTableHeaderView.self, forHeaderFooterViewReuseIdentifier: ChatTableHeaderView.identifier)
    }
    
    private let messageContainer = UIView().then {
        $0.addCorner(rad: 8, borderColor: nil)
        $0.backgroundColor = AssetsColors.gray1.color
    }
    private let messageTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.autocorrectionType = .no
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.showsVerticalScrollIndicator = false
        $0.textContainer.lineBreakMode = .byTruncatingTail
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    private let sendButton = UIButton().then {
        $0.setImage(AssetsImages.sendImpossible.image, for: .normal)
    }
    
//    let testRelay = BehaviorRelay<[ChatItemViewModel]>(value: [
//        ChatItemViewModel(userType: .me, message: "나", time: "11:11"),
//        ChatItemViewModel(userType: .you, message: "너", time: "22:22"),
//        ChatItemViewModel(userType: .you, message: "너", time: "33:33"),
//        ChatItemViewModel(userType: .you, message: "너", time: "44:44"),
//        ChatItemViewModel(userType: .me, message: "나", time: "55:55"),
//        ChatItemViewModel(userType: .you, message: "너", time: "66:66"),
//        ChatItemViewModel(userType: .me, message: "나", time: "77:77"),
//        ChatItemViewModel(userType: .you, message: "너", time: "88:88")
//    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [messageTextView, sendButton].forEach { messageContainer.addSubview($0) }
        [chatTableView, messageContainer].forEach { view.addSubview($0) }
        
        messageContainer.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(0)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.leading.equalToSuperview().offset(12)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(messageTextView)
            make.leading.equalTo(messageTextView.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview().inset(16)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(messageTextView.snp.top).offset(-16)
        }
        
        chatTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func binding() {
        let input = ChatViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asDriver(),
            sendButtonTap: sendButton.rx.tap.withLatestFrom(messageTextView.rx.text.orEmpty).asDriver(onErrorJustReturn: ""),
            messageText: messageTextView.rx.text.orEmpty
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.chatMessages
            .asDriver()
            .drive(chatTableView.rx.items(
                cellIdentifier: ChatTableViewCell.identifier,
                cellType: ChatTableViewCell.self)) { row, item, cell in
                    cell.configure(with: item)
                }.disposed(by: disposeBag)
        
        output.messageTextViewScrollEnabled
            .asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .drive { [weak self] in
                self?.updateMessageTextViewHeight(isLimited: $0)
                self?.messageTextView.isScrollEnabled = $0
            }.disposed(by: disposeBag)
        
        RxKeyboard.instance.willShowVisibleHeight
            .drive { [weak self] in
                let safeArea = self?.view.safeAreaInsets.bottom ?? 0.0
                self?.keyboardHandling(of: .show(height: $0, safeAreaBottom: safeArea))
            }.disposed(by: disposeBag)
        
        view.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
                self?.keyboardHandling(of: .hide)
            }).disposed(by: disposeBag)
                        
    }
    
    private func updateMessageTextViewHeight(isLimited: Bool) {
        if isLimited {
            messageContainer.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(100)
            }
        } else {
            messageContainer.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(0)
            }
        }
    }
    
    private func keyboardHandling(of status: KeyboardStatus) {
        let additional: CGFloat = status == KeyboardStatus.hide ? 0 : 16
        messageContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
                .inset(16 + additional + status.height - status.safeAreaBottom)
        }
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
