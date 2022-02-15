//
//  UserSearchStackView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/10.
//

import UIKit
import Then
import SnapKit

enum TopTabButtonStatus {
    case selected
    case unselected
    
    var color: UIColor {
        switch self {
        case .selected:
            return AssetsColors.green.color
        case .unselected:
            return AssetsColors.gray6.color
        }
    }
}

final class TopTabButton: UIView {
    let tabButton = UIButton().then {
        $0.titleLabel?.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    private let bottomBar = UIView()
    
    var status: TopTabButtonStatus = .selected {
        didSet {
            updateStatus(status: status)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(title: String, status: TopTabButtonStatus) {
        self.init()
        viewConfig()
        self.status = status
        updateStatus(status: status)
        tabButton.setTitle(title, for: .normal)
    }
    
    private func viewConfig() {
        [tabButton, bottomBar].forEach { addSubview($0) }
        bottomBar.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.leading.trailing.equalToSuperview()
        }
        tabButton.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBar.snp.top)
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func updateStatus(status: TopTabButtonStatus) {
        bottomBar.backgroundColor = status.color
        tabButton.setTitleColor(status.color, for: .normal)
    }
}
