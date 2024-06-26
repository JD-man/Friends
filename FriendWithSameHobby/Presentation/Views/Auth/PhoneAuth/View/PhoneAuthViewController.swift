//
//  PhoneAuthViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class PhoneAuthViewController: UIViewController {
    
    var viewModel: PhoneAuthViewModel?
    private var disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)        
    }
    
    private let phoneNumberTextField = BaseTextField(text: "휴대폰 번호(-없이 숫자만 입력)", status: .inactive).then {
        $0.inputTextField.keyboardType = .numberPad
    }
    private let requestPhoneNumberButton = BaseButton(title: "인증 문자 받기", status: .disable, type: .h48)
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        view.backgroundColor = .systemBackground
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        navigationItem.hidesBackButton = true
        [titleLabel, phoneNumberTextField, requestPhoneNumberButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.top.equalTo(titleLabel.snp.bottom).offset(77)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        requestPhoneNumberButton.snp.makeConstraints { make in
            make.height.equalTo(requestPhoneNumberButton.frame.height)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(72)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func binding() {
        let textFieldRx = phoneNumberTextField.inputTextField.rx
        
        let input = PhoneAuthViewModel.Input(
            phoneNumberText: textFieldRx.text.orEmpty.asDriver(onErrorJustReturn: "").distinctUntilChanged(),
            buttonTap: requestPhoneNumberButton.rx.tap.map({ [weak self] in
                guard let strongSelf = self else { return (.disable, "") }
                return (strongSelf.requestPhoneNumberButton.status,
                        strongSelf.phoneNumberTextField.inputTextField.text ?? "")
            }).asDriver(onErrorJustReturn: (.disable, ""))
        ) // 여기 너무 긴데 팁좀...
        
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        output?.formattedNumberRelay
            .asDriver(onErrorJustReturn: "")
            .drive(phoneNumberTextField.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        output?.buttonStatusRelay
            .asDriver(onErrorJustReturn: .disable)
            .drive(requestPhoneNumberButton.rx.status)
            .disposed(by: disposeBag)
        
        output?.textFieldStatusRelay
            .asDriver(onErrorJustReturn: .disable)
            .drive(phoneNumberTextField.rx.status)
            .disposed(by: disposeBag)
        
        // Edit Begin
        phoneNumberTextField.inputTextField.rx.controlEvent(.editingDidBegin)
            .map { BaseTextFieldStatus.active }
            .asDriver(onErrorJustReturn: .inactive)
            .drive(phoneNumberTextField.rx.status)
            .disposed(by: disposeBag)
    }
}
