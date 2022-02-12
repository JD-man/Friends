//
//  EmptyUserListView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/10.
//
import UIKit
import SnapKit
import Then

enum EmptyListCase {
    case around
    case requested
    
    var title: String {
        switch self {
        case .around:
            return "아쉽게도 주변에 새싹이 없어요 ㅋ"
        case .requested:
            return "아직 받은 요청이 없어요 ㅋ"
        }
    }
    
    var subtitle: String {
        switch self {
        default:
            return "취미를 변경하거나 조금만 더 기다려 주세요!"
        }
    }
}

final class EmptyUserListView: UIView {
    private let emptyImageView = UIImageView().then {
        $0.image = AssetsImages.emptyList.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 20)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(of listCase: EmptyListCase) {
        self.init()
        titleLabel.text = listCase.title
        subtitleLabel.text = listCase.subtitle
    }
    
    private func viewConfig() {
        backgroundColor = .systemBackground
        [emptyImageView, titleLabel, subtitleLabel]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16).priority(.low)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerX.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel.snp.top).offset(-32)
        }                
    }
}
