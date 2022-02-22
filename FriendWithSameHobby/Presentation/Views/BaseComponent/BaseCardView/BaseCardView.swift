//
//  BaseCardView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit
import SnapKit

enum BaseCardViewType {
    case profile
    case matching
}

final class BaseCardView: UIView {
    
    let nicknameLabel = UILabel().then {
        $0.text = UserInfoManager.nick ?? "Tester"
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 16)
    }
    
    let moreButton = UIButton().then {
        $0.tintColor = AssetsColors.gray7.color
        $0.setBackgroundImage(AssetsImages.moreArrow.image, for: .normal)
    }
    
    let sesacTitleView = SeSACTitleView()
    let hobbyTagView = SeSACHobbyTagView()
    let sesacCommentView = SeSACCommentView()
    
    var titleViewHeight = 0
    var commentViewHeight = 0
    var tagViewHeight = 0
    
    var isExpanding: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(type: BaseCardViewType) {
        self.init()
        viewConfig(type: type)
    }
    
    private func viewConfig(type: BaseCardViewType) {        
        addCorner(rad: 5, borderColor: AssetsColors.gray2.color)
        
        [nicknameLabel, moreButton, sesacTitleView, hobbyTagView, sesacCommentView]
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
        
        sesacCommentView.snp.makeConstraints { make in
            make.top.equalTo(hobbyTagView.snp.bottom)
            make.leading.trailing.equalTo(self).inset(16)
            make.bottom.equalTo(self).offset(-16).priority(.low)
        }
        
        switch type {
        case .profile:
            hobbyTagView.snp.makeConstraints { make in
                make.top.equalTo(sesacTitleView.snp.bottom).offset(24)
                make.leading.trailing.equalTo(self).inset(16)
                make.height.equalTo(0)
            }
            hobbyTagView.isHidden = true
            
        case .matching:
            hobbyTagView.snp.makeConstraints { make in
                make.top.equalTo(sesacTitleView.snp.bottom).offset(24)
                make.leading.trailing.equalTo(self).inset(16)
                make.bottom.equalTo(sesacCommentView.snp.top).offset(-24).priority(.low)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentViewHeight = Int(sesacCommentView.frame.height)
        titleViewHeight = Int(sesacTitleView.frame.height)
        tagViewHeight = Int(hobbyTagView.frame.height)
        
        //expanding(isExpanding: isExpanding)
    }
    
    private func expanding(isExpanding: Bool) {
        sesacTitleView.isHidden = isExpanding
        sesacCommentView.isHidden = isExpanding
        let constant = isExpanding ? 30 + tagViewHeight + commentViewHeight + titleViewHeight : -16
        sesacCommentView.snp.updateConstraints({ make in
            make.bottom.equalTo(self).offset(constant)
        })        
    }
    
    func buttonConfig(with data: [BaseButtonStatus]) {
        sesacTitleView.buttonConfig(with: data)
    }
}
