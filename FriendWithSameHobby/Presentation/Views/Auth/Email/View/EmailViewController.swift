//
//  EmailViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class EmailViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "이메일을 입력해 주세요"
        $0.textColor = AssetsColors.black.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = AssetsColors.gray7.color
        $0.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 16)
    }
    
    private let emailTextField = BaseTextField(text: "SeSAC@email.com", status: .inactive)
    private let nextButton = BaseButton(title: "다음", status: .disable, type: .h48)
    
    var viewModel: EmailViewModel?
    
    init(viewModel: EmailViewModel) {
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
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [titleLabel, subtitleLabel, emailTextField, nextButton]
            .forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(76)
            make.height.greaterThanOrEqualTo(emailTextField.frame.height)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(nextButton.frame.height)
            make.top.equalTo(emailTextField.lineView.snp.bottom).offset(72)
        }
    }
    
    private func binding() {
        
    }
}
