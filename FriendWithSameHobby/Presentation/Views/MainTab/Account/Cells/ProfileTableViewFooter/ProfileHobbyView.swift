//
//  ProfileHobbyView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//
import UIKit
import SnapKit
import Then

final class ProfileHobbyView: UIView {
    let titleLabel = UILabel().then {
        $0.text = "자주 하는 취미"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    let hobbyTextField = BaseTextField(text: "취미를 입력해 주세요", status: .inactive)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        [titleLabel, hobbyTextField]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalTo(self)
        }
        
        hobbyTextField.snp.makeConstraints { make in
            make.trailing.equalTo(self)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(self).multipliedBy(0.5)            
        }
    }
}
