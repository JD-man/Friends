//
//  SeSACTitleView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit
import SnapKit

final class SeSACTitleView: UIView {
    let titleLabel = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    let mannerButton = BaseButton(title: "좋은 매너", status: .inactive, type: .h32)
    let punctualButton = BaseButton(title: "정화한 시간 약속", status: .inactive, type: .h32)
    let quickResponseButton = BaseButton(title: "빠른 응답", status: .inactive, type: .h32)
    let kindButton = BaseButton(title: "친절한 성격", status: .inactive, type: .h32)
    let proficientButton = BaseButton(title: "능숙한 취미 실력", status: .inactive, type: .h32)
    let gootTimeButton = BaseButton(title: "유익한 시간", status: .inactive, type: .h32)
    
    let firstHStackView = UIStackView()
    let secondHStackView = UIStackView()
    let thirdHStackView = UIStackView()
    
    let verticalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configStackViews()
        viewConfig()
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
        thirdHStackView.addArrangedSubview(gootTimeButton)
        
        verticalStackView.spacing = 8
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.addArrangedSubview(firstHStackView)
        verticalStackView.addArrangedSubview(secondHStackView)
        verticalStackView.addArrangedSubview(thirdHStackView)
    }
}
