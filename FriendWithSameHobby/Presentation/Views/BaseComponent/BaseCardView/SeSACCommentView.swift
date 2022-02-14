//
//  SeSACReviewView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//
import UIKit
import SnapKit

enum ReviewLabelStatus {
    case empty
    case exist(text: String)
    
    var text: String {
        switch self {
        case .empty:
            return "첫 리뷰를 기다리는 중이에요!"
        case .exist(let text):
            return text
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .empty:
            return AssetsColors.gray6.color
        case .exist:
            return AssetsColors.black.color
        }
    }
    
    var isMoreButtonHidden: Bool {
        switch self {
        case .empty:
            return true
        case .exist:
            return false
        }
    }
}

final class SeSACCommentView: UIView {
    private let titleLabel = UILabel().then {
        $0.text = "새싹 리뷰"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    let moreButton = UIButton().then {
        $0.tintColor = AssetsColors.gray7.color
        $0.setBackgroundImage(AssetsImages.moreArrow.image, for: .normal)
    }
    
    let reviewLabel = UILabel().then {
        $0.text = "첫 리뷰를 기다리는 중이에요!"
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
    
    func reviewLabelConfig(status: ReviewLabelStatus) {
        reviewLabel.text = status.text
        reviewLabel.textColor = status.textColor
        moreButton.isHidden = status.isMoreButtonHidden
    }
}
