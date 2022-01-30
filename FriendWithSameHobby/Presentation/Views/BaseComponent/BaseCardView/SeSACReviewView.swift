//
//  SeSACReviewView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//
import UIKit
import SnapKit

final class SeSACReviewView: UIView {
    let titleLabel = UILabel().then {
        $0.text = "새싹 리뷰"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    let moreButton = UIButton().then {
        $0.tintColor = AssetsColors.gray7.color
        $0.setBackgroundImage(AssetsImages.moreArrow.image, for: .normal)
    }
    
    let reviewLabel = UILabel().then {
        $0.text = "리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 리뷰 "
        $0.numberOfLines = 0
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        [titleLabel, moreButton, reviewLabel]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.height.equalTo(16)
            make.trailing.equalTo(self)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
}
