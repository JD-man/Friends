//
//  HobbyCollectionViewCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/08.
//

import UIKit
import Then
import SnapKit
import RxSwift

enum HobbyCellStatus: Equatable {
    case recommend
    case around
    case added
    
    var buttonStatus: BaseButtonStatus {
        switch self {
        case .recommend:
            return .outline(color: AssetsColors.error.color)
        case .around:
            return .outline(color: AssetsColors.black.color)
        case .added:
            return .outline(color: AssetsColors.green.color)
        }
    }
}

final class HobbyCollectionViewCell: UICollectionViewCell {
    deinit {
        print("hobby cell deinit")
    }
    
    var disposeBag = DisposeBag()
    
    let tagButton = BaseButton(title: "태그", status: .fill, type: .h32)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {        
        addSubview(tagButton)
        tagButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
    }
    
    func configure(with model: HobbyCellModel) {
        tagButton.setTitle(model.cellTitle, for: .normal)
        tagButton.status = model.status.buttonStatus
        tagButton.frame.size.width = tagButton.titleLabel?.frame.size.width ?? 0 + 30
        tagButton.frame.size.height = tagButton.titleLabel?.frame.size.height ?? 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
