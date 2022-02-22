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
    case empty
    
    var buttonStatus: BaseButtonStatus {
        switch self {
        case .recommend:
            return .outline(color: AssetsColors.error.color)
        case .around:
            return .outline(color: AssetsColors.black.color)
        case .added:
            return .outline(color: AssetsColors.green.color)
        case .empty:
            return .outline(color: .clear)
        }
    }
}

final class HobbyCollectionViewCell: UICollectionViewCell {
    deinit {
        print("tag cell deinit")
    }
    
    var disposeBag = DisposeBag()
    
    let tagButton = BaseButton(title: "태그", status: .fill, type: .h32)
    let emptyLabel = PaddedLabel(top: 5, left: 10, bottom: 5, right: 10).then {
        $0.numberOfLines = 1
        $0.textColor = .clear
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        [emptyLabel, tagButton]
            .forEach { addSubview($0) }
        
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tagButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with model: HobbyItemViewModel) {
        tagButton.setTitle(model.cellTitle, for: .normal)
        tagButton.status = model.status.buttonStatus
        emptyLabel.text = model.cellTitle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
