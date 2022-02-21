//
//  FaceProductCollectionViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/20.
//

import UIKit
import SnapKit
import Then
import RxSwift

class FaceProductCollectionViewCell: UICollectionViewCell {
    
    private let faceImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.addCorner(rad: 8, borderColor: AssetsColors.gray3.color)
    }

    private let productDescriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    let purchaseButton = BaseButton(title: "가격", status: .disable, type: .h32).then {
        $0.titleLabel?.font = AssetsFonts.NotoSansKR.medium.font(size: 12)
    }
    
    let productNameLabel = UILabel().then {
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func viewConfig() {
        [faceImageView, productNameLabel,
         productDescriptionLabel, purchaseButton]
            .forEach { contentView.addSubview($0) }
        
        faceImageView.snp.makeConstraints { make in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(faceImageView.snp.width)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(faceImageView.snp.leading)
            make.top.equalTo(faceImageView.snp.bottom).offset(8)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel)
            make.width.equalTo(52)
            make.height.equalTo(20)
            make.trailing.equalTo(faceImageView.snp.trailing)
        }
        
        productDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(faceImageView)
            make.bottom.equalToSuperview().priority(.low)
        }
    }
    
    func configure(with data: FaceShopItemViewModel) {
        faceImageView.image = data.faceImage.imageAsset.image
        productNameLabel.text = data.productName
        productDescriptionLabel.text = data.description
        purchaseButton.status = data.isPurchased ? .disable : .fill
        purchaseButton.isUserInteractionEnabled = !data.isPurchased
        purchaseButton.setTitle(data.isPurchased ? "보유" : data.price, for: .normal)
    }
}
