//
//  ChatMeTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/15.
//

import UIKit
import SnapKit
import Then

class ChatTableViewCell: UITableViewCell {
    
    private let messageLabel = PaddedLabel(top: 10, left: 16, bottom: 10, right: 16).then {
        $0.numberOfLines = 0
        $0.clipsToBounds = true
        $0.textAlignment = .right        
        $0.addCorner(rad: 8, borderColor: nil)
        $0.textColor = AssetsColors.black.color
        $0.backgroundColor = AssetsColors.whiteGreen.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "15:02"
        $0.textColor = AssetsColors.gray6.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        selectionStyle = .none
        backgroundColor = .systemBackground
        [messageLabel, timeLabel].forEach { contentView.addSubview($0) }
        
        messageLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(contentView).inset(16)
            make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(264.0 / 375.0)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageLabel)
            make.trailing.equalTo(messageLabel.snp.leading).offset(-8)
        }
    }
    
    func configure(with data: ChatItemViewModel) {
        timeLabel.text = data.time
        messageLabel.text = data.message        
    }
}
