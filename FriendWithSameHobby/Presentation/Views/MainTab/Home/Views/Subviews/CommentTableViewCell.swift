//
//  CommentTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//

import UIKit
import Then
import SnapKit

class CommentTableViewCell: UITableViewCell {
    
    private let reviewLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        contentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with data: String) {
        reviewLabel.text = data
    }
}
