//
//  VerifyViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import UIKit
import SnapKit
import Then
import RxSwift

class VerifyViewController: UIViewController {
    
    var viewModel: VerifyViewModel?
    private var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "인증번호가 문자로 전송되었어요"
        $0.textColor = AssetsColors.black.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "(최대 소모 20초)" // Timeout???????????
        $0.textAlignment = .center
        $0.textColor = AssetsColors.gray7.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 16)
    }
    
    let timerLabel = UILabel().then {
        $0.text = "05:00"
        $0.textColor = AssetsColors.green.color
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    let retryButton = BaseButton(title: "재전송", status: .fill, type: .h48)
    let verifyButton = BaseButton(title: "인증하고 시작하기", status: .disable, type: .h48)
    let verifyTextField = BaseTextField(text: "인증번호 입력", status: .inactive).then {
        $0.inputTextField.keyboardType = .numberPad
    }   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [titleLabel, subtitleLabel, retryButton, verifyTextField, timerLabel, verifyButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        retryButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(retryButton.frame.height)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(70)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        verifyTextField.snp.makeConstraints { make in
            make.top.equalTo(retryButton)
            make.height.greaterThanOrEqualTo(48)
            make.trailing.equalTo(retryButton.snp.leading).offset(-8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(retryButton.snp.leading).offset(-20)
            make.centerY.equalTo(verifyTextField.inputTextField.snp.centerY)
        }
        
        verifyButton.snp.makeConstraints { make in
            make.height.equalTo(verifyButton.frame.height)
            make.top.equalTo(retryButton.snp.bottom).offset(74)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func binding() {
        let input = VerifyViewModel.Input(veriftButtonTap: verifyButton.rx.tap,
                                          retryButtonTap: retryButton.rx.tap,
                                          verifyTextFieldText: verifyTextField.inputTextField.rx.text.orEmpty,
                                          verifyTextFieldEditBegin: verifyTextField.inputTextField.rx.controlEvent(.editingDidBegin))
        
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        output?.verifyButtonStatus
            .asDriver(onErrorJustReturn: .disable)
            .drive { [weak self] in
                self?.verifyButton.statusUpdate(status: $0)
            }.disposed(by: disposeBag)
        
        output?.emptyStringRelay
            .asDriver(onErrorJustReturn: "")
            .drive(verifyTextField.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        output?.textFieldStatus
            .asDriver(onErrorJustReturn: .disable)
            .drive { [weak self] in
                self?.verifyTextField.statusUpdate(status: $0)
            }.disposed(by: disposeBag)
    }
}
