//
//  NicknameViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

class NicknameViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "닉네임을 입력해 주세요"
        $0.textColor = AssetsColors.black.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)
    }
    
    private let nicknameTextField = BaseTextField(text: "10자 이내로 입력", status: .inactive).then {
        $0.inputTextField.text = UserInfoManager.nick
    }
    private let nextButton = BaseButton(title: "다음", status: .disable, type: .h48)
    
    var viewModel: NickNameViewModel?
    private var disposeBag = DisposeBag()
    
    init(viewModel: NickNameViewModel) {
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
    
    func viewConfig() {
        view.backgroundColor = .systemBackground
        [titleLabel, nicknameTextField, nextButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(97)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(93)
            make.height.greaterThanOrEqualTo(nicknameTextField.frame.height)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(nextButton.frame.height)
            make.top.equalTo(nicknameTextField.lineView.snp.bottom).offset(72)
        }
    }
    
    func binding() {        
        let input = NickNameViewModel.Input(            
            textFieldText: nicknameTextField.inputTextField.rx.text.orEmpty.asDriver(),
            nextButtonTap: nextButton.rx.tap.map { [weak self] in
                self?.nicknameTextField.inputTextField.text ?? ""
            }.asDriver(onErrorJustReturn: ""))        
        
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        output?.textFieldStatus
            .asDriver(onErrorJustReturn: .inactive)
            .drive { [weak self] in
                guard let status = $0 else { return }
                self?.nicknameTextField.statusUpdate(status: status)
            }.disposed(by: disposeBag)
        
        output?.nextButtonStatus
            .asDriver()
            .drive { [weak self] in
                self?.nextButton.statusUpdate(status: $0)
            }.disposed(by: disposeBag)        
        
        // Edit Begin
        
        nicknameTextField.inputTextField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive { [weak self] _ in
                self?.nicknameTextField.statusUpdate(status: .focus)
            }.disposed(by: disposeBag)            
    }
}
