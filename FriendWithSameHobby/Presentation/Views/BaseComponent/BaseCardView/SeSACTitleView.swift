//
//  SeSACTitleView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit
import SnapKit
import RxSwift

final class SeSACTitleView: UIView {
    
    private var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    private let mannerButton = BaseButton(title: "좋은 매너", status: .inactive, type: .h32)
    private let punctualButton = BaseButton(title: "정확한 시간 약속", status: .inactive, type: .h32)
    private let quickResponseButton = BaseButton(title: "빠른 응답", status: .inactive, type: .h32)
    private let kindButton = BaseButton(title: "친절한 성격", status: .inactive, type: .h32)
    private let proficientButton = BaseButton(title: "능숙한 취미 실력", status: .inactive, type: .h32)
    private let goodTimeButton = BaseButton(title: "유익한 시간", status: .inactive, type: .h32)
    
    private let firstHStackView = UIStackView()
    private let secondHStackView = UIStackView()
    private let thirdHStackView = UIStackView()
    
    let verticalStackView = UIStackView()
    
    var reputation: [BaseButtonStatus] {
        get {
            [mannerButton, punctualButton,
             quickResponseButton, kindButton,
             proficientButton, goodTimeButton].map { $0.status }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configStackViews()
        viewConfig()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        [titleLabel, verticalStackView]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    private func configStackViews() {
        [firstHStackView, secondHStackView, thirdHStackView]
            .forEach {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.spacing = 16
            }
        
        firstHStackView.addArrangedSubview(mannerButton)
        firstHStackView.addArrangedSubview(punctualButton)
        
        secondHStackView.addArrangedSubview(quickResponseButton)
        secondHStackView.addArrangedSubview(kindButton)
        
        thirdHStackView.addArrangedSubview(proficientButton)
        thirdHStackView.addArrangedSubview(goodTimeButton)
        
        verticalStackView.spacing = 8
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.addArrangedSubview(firstHStackView)
        verticalStackView.addArrangedSubview(secondHStackView)
        verticalStackView.addArrangedSubview(thirdHStackView)
    }
    
    func buttonConfig(with data: [BaseButtonStatus]) {
        let buttons = [mannerButton, punctualButton, quickResponseButton,
                       kindButton, proficientButton, goodTimeButton]
        
        zip(buttons, data)
            .forEach {
                $0.0.isUserInteractionEnabled = false
                $0.0.status = $0.1
            }
    }
    
    private func binding() {
        let buttons = [mannerButton, punctualButton, quickResponseButton,
                       kindButton, proficientButton, goodTimeButton]
        
        buttons.forEach { button in
            button.rx.tap
                .asDriver()
                .drive { [weak button] _ in
                    button?.status = .fill
                }.disposed(by: disposeBag)
        }
    }
}
