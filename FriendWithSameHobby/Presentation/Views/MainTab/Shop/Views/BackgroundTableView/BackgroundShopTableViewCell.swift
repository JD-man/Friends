//
//  BackgroundShopTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/20.
//

import UIKit
import SnapKit
import Then

class BackgroundShopTableViewCell: UITableViewCell {
    
    private let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addCorner(rad: 8, borderColor: nil)
    }
    private let productNameLabel = UILabel().then {
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    private let productDescriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    private let purchaseButton = BaseButton(title: "가격", status: .disable, type: .h32).then {
        $0.titleLabel?.font = AssetsFonts.NotoSansKR.medium.font(size: 12)
    }
    
    private lazy var namePurchaseStackView = UIStackView(
        arrangedSubviews: [productNameLabel, purchaseButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fill
        }
    
    private lazy var verticalStackView = UIStackView(
        arrangedSubviews: [namePurchaseStackView, productDescriptionLabel]).then {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.spacing = 8
        }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        [backgroundImageView, verticalStackView].forEach { contentView.addSubview($0) }
        backgroundImageView.snp.makeConstraints { make in
            make.width.height.equalTo(165)
            make.top.leading.bottom.equalTo(contentView).inset(16)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-17)            
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(12)
        }
    }
    
    func configure(with data: BackgroundShopItemViewModel) {
        backgroundImageView.image = data.backgroundImage.imageAsset.image
        productNameLabel.text = data.productName
        productDescriptionLabel.text = data.description
    }
}
