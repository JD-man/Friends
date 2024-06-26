//
//  RegisterViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "성별을 선택해 주세요"
        $0.textColor = AssetsColors.black.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = AssetsColors.gray7.color
        $0.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 16)
    }
    
    private let maleButton = UIButton().then {
        $0.setBackgroundImage(AssetsImages.maleButton.image, for: .normal)        
    }
    
    private let femaleButton = UIButton().then {
        $0.setBackgroundImage(AssetsImages.femaleButton.image, for: .normal)
    }
    
    private let registerButton = BaseButton(title: "다음", status: .fill, type: .h48)

    let viewModel: RegisterViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [titleLabel, subtitleLabel, maleButton, femaleButton, registerButton]
            .forEach { view.addSubview($0) }
        
        let buttonWidth = (UIScreen.main.bounds.width - (16 * 3)) / 2
        
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
        // 120 * 166
        maleButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonWidth * 120 / 166)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.top.equalTo(maleButton)
            make.height.equalTo(maleButton)
            make.leading.equalTo(maleButton.snp.trailing).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(registerButton.frame.height)
            make.top.equalTo(maleButton.snp.bottom).offset(32)
        }
    }
    
    private func binding() {
        let input = RegisterViewModel.Input(
            maleButtonTap: maleButton.rx.tap,
            femaleButtonTap: femaleButton.rx.tap,
            registerTap: registerButton.rx.tap.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.selectedGender
            .map { $0 == .male ? AssetsColors.whiteGreen.color : AssetsColors.white.color}
            .bind(to: femaleButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.selectedGender
            .map { $0 == .female ? AssetsColors.whiteGreen.color : AssetsColors.white.color }
            .bind(to: maleButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
