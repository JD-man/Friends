//
//  MenuButton.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import UIKit
import Then
import SnapKit

final class MenuButton: UIButton {
    
    private let menuImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }
    
    private let menuTitleLabel = UILabel().then {
        $0.isUserInteractionEnabled = false
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(title: String, image: UIImage) {
        self.init()
        viewConfig()
        menuImage.image = image
        menuTitleLabel.text = title
    }
    
    private func viewConfig() {
        backgroundColor = .systemBackground
        [menuImage, menuTitleLabel].forEach { addSubview($0) }
        menuImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        menuTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(menuImage.snp.bottom).offset(6.5)
        }
    }
}
