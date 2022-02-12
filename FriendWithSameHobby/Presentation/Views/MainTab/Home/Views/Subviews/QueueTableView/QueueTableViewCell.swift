//
//  QueueTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/11.
//

import UIKit
import Then
import SnapKit
import RxSwift

enum MatchingButtonStatus {
    case request
    case allow
    
    var backgroundColor: UIColor {
        switch self {
        case .allow:
            return AssetsColors.success.color
        case .request:
            return AssetsColors.error.color
        }
    }
    
    var title: String {
        switch self {
        case .allow:
            return "수락하기"
        case .request:
            return "요청하기"
        }
    }
}

class QueueTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addCorner(rad: 5, borderColor: nil)
        $0.image = AssetsImages.sesacBg01.image
    }
    
    let sesacImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = AssetsImages.sesacFace2.image
    }
    
    let matchingButton = UIButton().then {        
        $0.addCorner(rad: 8, borderColor: nil)
        $0.titleLabel?.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
        $0.setTitleColor(AssetsColors.white.color, for: .normal)
    }
    
    let baseCardView = BaseCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        selectionStyle = .none
        [backgroundImageView, sesacImageView, baseCardView, matchingButton]
            .forEach { contentView.addSubview($0) } // contentView에 안하면 backgroundView랑 레이아웃 에러나옴.
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(backgroundImageView.snp.width).multipliedBy(194.0 / 343.0)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(9)
            make.leading.equalTo(backgroundImageView.snp.leading).offset(75)
            make.trailing.equalTo(backgroundImageView.snp.trailing).offset(-84)
            make.height.equalTo(backgroundImageView.snp.width).multipliedBy(184.0 / 343.0)
        }
        
        baseCardView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-16)
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.leading.trailing.equalTo(backgroundImageView)
        }
        
        matchingButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.trailing.equalTo(backgroundImageView).inset(12)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func expand(_ isExpanding: Bool) {
        baseCardView.expanding(isExpanding: isExpanding)
    }
    
    func configure(with data: MatchingItemViewModel) {
        baseCardView.nicknameLabel.text = data.nick
        baseCardView.buttonConfig(with: data.reputation)
        sesacImageView.image = data.sesac.imageAsset.image
        baseCardView.expanding(isExpanding: data.expanding)
        backgroundImageView.image = data.background.imageAsset.image
        
        matchingButton.setTitle(data.matchingButtonStatus.title, for: .normal)
        matchingButton.backgroundColor = data.matchingButtonStatus.backgroundColor
        
        if let firstReview = data.review.first {
            baseCardView.sesacReviewView.reviewLabelConfig(status: .exist(text: firstReview))
        } else {
            baseCardView.sesacReviewView.reviewLabelConfig(status: .empty)
        }
    }
}
