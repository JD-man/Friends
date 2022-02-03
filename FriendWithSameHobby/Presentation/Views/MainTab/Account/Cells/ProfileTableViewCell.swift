//
//  ProfileTableViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit
import SnapKit
import RxSwift
import Then

class ProfileTableViewCell: UITableViewCell {
    deinit {
        print("cell deinit")
    }
    
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
    
    var baseCardView = BaseCardView()
    var disposeBag = DisposeBag()
    
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
            .forEach { contentView.addSubview($0) }
        
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
    
    func expand(_ isExpanding: Bool) {
        baseCardView.expanding(isExpanding: isExpanding)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
