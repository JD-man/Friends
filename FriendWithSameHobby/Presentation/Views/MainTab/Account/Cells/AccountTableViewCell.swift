//
//  AccountTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let rowTitleLabel = UILabel().then {
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 16)
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
        [iconImageView, rowTitleLabel]
            .forEach { contentView.addSubview($0) }
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(17)
            make.width.height.equalTo(24)
            make.centerY.equalTo(contentView)
        }        
        rowTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalTo(iconImageView)
            make.trailing.equalTo(contentView).offset(-17)
        }
    }
    
    func configure(with model: AccountCellModel) {
        rowTitleLabel.text = model.titleText
        iconImageView.image = model.iconImage        
    }
}
