//
//  ChatTableHeaderView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/15.
//

import UIKit
import SnapKit
import Then

class ChatTableHeaderView: UITableViewHeaderFooterView {
    
    private let dateLabel = PaddedLabel(top: 4, left: 16, bottom: 4, right: 16).then {
        $0.clipsToBounds = true
        $0.text = Date().currentDate
        $0.textColor = .systemBackground
        $0.addCorner(rad: 10, borderColor: nil)
        $0.backgroundColor = AssetsColors.gray7.color
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 12)
    }
    private let bellImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = AssetsColors.gray7.color
        $0.image = AssetsImages.settingAlarm.image
    }
    private let titleLabel = UILabel().then {
        $0.text = "OOO님과 매칭되었습니다"
        $0.textColor = AssetsColors.gray7.color
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    private let subtitleLabel = UILabel().then {
        $0.text = "채팅을 통해 약속을 정해보세요 :)"
        $0.textColor = AssetsColors.gray6.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func viewConfig() {
        [dateLabel, titleLabel, bellImageView, subtitleLabel]
            .forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(4)
        }
        
        bellImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(16)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-4)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
