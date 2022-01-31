//
//  ProfileAllowSearchingView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//
import UIKit

final class ProfileAllowSearchingView: UIView {
    let titleLabel = UILabel().then {
        $0.text = "내 번호 검색 허용"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    let allowSwitch = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        [titleLabel, allowSwitch]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalTo(self)
        }
        
        allowSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(52)
            make.height.equalTo(28)
            make.trailing.equalTo(self)
        }
    }
}
