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
        $0.backgroundColor = .clear
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        $0.register(ChatYouTableViewCell.self, forCellReuseIdentifier: ChatYouTableViewCell.identifier)
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
    
    private let backButton = UIBarButtonItem().then {
        $0.style = .plain
        $0.image = AssetsImages.arrow.image
    }
    private let moreButton = UIBarButtonItem().then {
        $0.style = .plain
        $0.image = AssetsImages.more.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = UserChatManager.otherNickname ?? ""
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
            make.trailing.equalToSuperview().offset(-46)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(messageTextView)
            make.leading.equalTo(messageTextView.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview().inset(16)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(messageContainer.snp.top).offset(-16)
        }
        
        chatTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // navigation config
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = moreButton
        navigationController?.navigationBar.isHidden = false
    }
    
    private func binding() {
        let input = ChatViewModel.Input(
            backButtonTap: backButton.rx.tap.asDriver(),
            moreButtonTap: moreButton.rx.tap.asDriver(),
            viewWillAppear: self.rx.viewWillAppear.asDriver(),
            sendButtonTap: sendButton.rx.tap.withLatestFrom(messageTextView.rx.text.orEmpty).asDriver(onErrorJustReturn: ""),
            messageText: messageTextView.rx.text.orEmpty
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.chatMessages
            .asDriver()
            .drive(chatTableView.rx.items) { tableView, row, item in
                switch item.userType {
                case .me:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier) as! ChatTableViewCell
                    cell.configure(with: item)
                    return cell
                case .you:
                    let cell = tableView.dequeueReusableCell(withIdentifier: ChatYouTableViewCell.identifier) as! ChatYouTableViewCell
                    cell.configure(with: item)
                    return cell
                }
            }.disposed(by: disposeBag)
        
        output.chatMessages
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
            .drive { [weak self] in
                guard $0 > 0 else { return }
                self?.chatTableView.scrollToRow(at: IndexPath(row: $0 - 1, section: 0),
                                                at: .middle,
                                                animated: false)
            }.disposed(by: disposeBag)
        
        output.initializeTextView
            .asDriver(onErrorJustReturn: "")
            .drive(messageTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.messageTextViewScrollEnabled
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                self?.updateMessageTextViewHeight(isLimited: $0)
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
        
        messageTextView.rx.text
            .orEmpty
            .asDriver()
            .drive { [weak self] in
                let isButtonActive = $0.count > 0
                let buttonImage = isButtonActive ? AssetsImages.sendPossible : AssetsImages.sendImpossible
                self?.sendButton.isUserInteractionEnabled = isButtonActive
                self?.sendButton.setImage(buttonImage.image, for: .normal)
            }.disposed(by: disposeBag)
    }
    
    private func updateMessageTextViewHeight(isLimited: Bool) {
        let height = messageTextView.text.components(separatedBy: "\n").count == 1 ? 0 : messageTextView.contentSize.height + 28        
        if isLimited {
            messageContainer.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(100)
            }
        } else {
            messageContainer.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(height)
            }
        }
        messageTextView.isScrollEnabled = isLimited
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
