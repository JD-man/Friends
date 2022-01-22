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
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)        
    }
    
    private let phoneNumberTextField = BaseTextField(text: "휴대폰 번호(-없이 숫자만 입력)", status: .inactive)
    private let requestPhoneNumberButton = BaseButton(title: "인증 문자 받기",
                                                status: .disable,
                                                type: .h48)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewConfig()
    }
    
    private func viewConfig() {
        navigationItem.hidesBackButton = true
        [titleLabel, phoneNumberTextField, requestPhoneNumberButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(125)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(74)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.top.equalTo(titleLabel.snp.bottom).offset(77)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        requestPhoneNumberButton.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(requestPhoneNumberButton.frame.height)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
