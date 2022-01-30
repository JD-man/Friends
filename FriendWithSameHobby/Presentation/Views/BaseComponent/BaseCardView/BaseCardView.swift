//
//  BaseCardView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BaseCardView: UIView {
    
    private var disposeBag = DisposeBag()
    
    let nicknameLabel = UILabel().then {
        $0.text = UserInfoManager.nick ?? "Tester"
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 16)
    }
    
    let moreButton = UIButton().then {
        $0.tintColor = AssetsColors.gray7.color
        $0.setBackgroundImage(AssetsImages.moreArrow.image, for: .normal)
    }
    
    let sesacTitleView = SeSACTitleView()
    let sesacReviewView = SeSACReviewView()
    
    let verticalStackView = UIStackView()
    
    var titleViewHeight = 0
    var reviewViewHeight = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        addCorner(rad: 5, borderColor: AssetsColors.gray2.color)
        
        [nicknameLabel, moreButton, sesacTitleView, sesacReviewView]
            .forEach { addSubview($0) }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(21)
            make.trailing.equalTo(self).offset(-18)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(moreButton)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(moreButton).offset(-16)
        }
        
        sesacTitleView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(self).inset(16)
        }
        
        sesacReviewView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(self).inset(16)
            make.bottom.equalTo(self).offset(-16).priority(.low)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reviewViewHeight = Int(sesacReviewView.frame.height)
        titleViewHeight = Int(sesacTitleView.frame.height)        
    }
    
    func expanding(isExpanding: Bool) {
        sesacTitleView.isHidden = isExpanding
        sesacReviewView.isHidden = isExpanding
        let constant = isExpanding ? 30 + reviewViewHeight + titleViewHeight : -16        
        sesacReviewView.snp.updateConstraints({ make in
            make.bottom.equalTo(self).offset(constant).priority(.low)
        })
    }
}
