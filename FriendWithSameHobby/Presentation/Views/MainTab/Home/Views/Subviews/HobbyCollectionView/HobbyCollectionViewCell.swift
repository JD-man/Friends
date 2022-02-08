//
//  HobbyCollectionViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/08.
//

import UIKit
import Then
import SnapKit

final class HobbyCollectionViewCell: UICollectionViewCell {
    
    private let tagButton = BaseButton(title: "태그", status: .outline, type: .h32).then {
        $0.addCorner(rad: 8, borderColor: AssetsColors.green.color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        contentView.addSubview(tagButton)
        tagButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with model: String) {
        tagButton.setTitle(model, for: .normal)
    }
}
