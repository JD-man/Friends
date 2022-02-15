//
//  ChatMeTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/15.
//

import UIKit
import SnapKit
import Then

enum ChatUserType {
    case me
    case you
}

class ChatTableViewCell: UITableViewCell {
    
    private let messageLabel = PaddedLabel(top: 10, left: 16, bottom: 10, right: 16).then {
        $0.numberOfLines = 0
        $0.clipsToBounds = true
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "15:02"
        $0.textColor = AssetsColors.gray6.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with data: ChatItemViewModel) {
        selectionStyle = .none
        [messageLabel, timeLabel].forEach { contentView.addSubview($0) }
        switch data.userType {
        case .me:
            meTypeConfig()
        case .you:
            youTypeConfig()
        }        
        timeLabel.text = data.time
        messageLabel.text = data.message        
    }
    
    private func meTypeConfig() {
        messageLabel.textAlignment = .left
        messageLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(contentView).inset(16)
            make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(264.0 / 375.0)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageLabel)
            make.leading.equalTo(messageLabel.snp.trailing).offset(8)
        }
        messageLabel.addCorner(rad: 8, borderColor: AssetsColors.gray4.color)
    }
    
    private func youTypeConfig() {
        messageLabel.textAlignment = .right
        messageLabel.backgroundColor = AssetsColors.whiteGreen.color
        messageLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(contentView).inset(16)
            make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(264.0 / 375.0)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageLabel)
            make.trailing.equalTo(messageLabel.snp.leading).offset(-8)
        }
        messageLabel.addCorner(rad: 8, borderColor: nil)
    }
}
