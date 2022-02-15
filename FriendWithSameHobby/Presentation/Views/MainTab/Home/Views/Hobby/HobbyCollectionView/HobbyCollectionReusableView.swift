//
//  HobbyCollectionReusableView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/09.
//

import UIKit
import Then
import SnapKit

class HobbyCollectionReusableView: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
