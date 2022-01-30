//
//  AccountTableHeaderView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/26.
//

import UIKit
import SnapKit

class AccountTableHeaderView: UITableViewHeaderFooterView {
    
    private let accountImageView = UIImageView().then {
        $0.frame.size.height = 50
        $0.contentMode = .scaleAspectFit
        $0.image = AssetsImages.profileImg.image
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = UserInfoManager.nick ?? "Tester"
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 16)
    }
    
    private let moreImageView = UIImageView().then {
        $0.frame.size.height = 24
        $0.contentMode = .scaleAspectFit
        $0.image = AssetsImages.moreArrow.image
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        [accountImageView, moreImageView, userNameLabel]
            .forEach { contentView.addSubview($0) }
        
        accountImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(15)
            make.width.height.equalTo(accountImageView.frame.height)
        }
        
        moreImageView.snp.makeConstraints { make in
            make.width.height.equalTo(moreImageView.frame.height)
            make.centerY.equalTo(accountImageView)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(accountImageView)
            make.leading.equalTo(accountImageView.snp.trailing).offset(13)
            make.trailing.equalTo(moreImageView.snp.leading).inset(13)
        }
    }
}
