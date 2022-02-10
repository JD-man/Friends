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
    
    let baseCardView = BaseCardView()
    
    private let popupButton = UIButton().then {
        $0.setTitle("요청 하기", for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        selectionStyle = .none
        [backgroundImageView, sesacImageView, baseCardView]
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
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.leading.trailing.equalTo(backgroundImageView)
            make.bottom.equalTo(contentView).offset(-16)
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
        baseCardView.expanding(isExpanding: data.expanding)
        backgroundImageView.image = data.background.imageAsset.image
        sesacImageView.image = data.sesac.imageAsset.image
        baseCardView.nicknameLabel.text = data.nick
        baseCardView.sesacReviewView.reviewLabel.text = data.review[0]
        
        // title button config
        baseCardView.buttonConfig(with: data.reputation)
    }
}
