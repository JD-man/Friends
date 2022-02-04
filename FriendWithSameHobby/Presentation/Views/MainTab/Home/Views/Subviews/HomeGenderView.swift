//
//  HomeGenderView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class HomeGenderView: UIView {
    private let allGenderButton = UIButton().then {
        $0.clipsToBounds = true
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(AssetsColors.black.color, for: .normal)
        $0.titleLabel?.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    private let maleButton = UIButton().then {
        $0.clipsToBounds = true
        $0.setTitle("남자", for: .normal)
        $0.setTitleColor(AssetsColors.black.color, for: .normal)
        $0.titleLabel?.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    private let femaleButton = UIButton().then {
        $0.clipsToBounds = true
        $0.setTitle("여자", for: .normal)
        $0.setTitleColor(AssetsColors.black.color, for: .normal)
        $0.titleLabel?.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    private lazy var buttonsStackView = UIStackView(
        arrangedSubviews: [allGenderButton, maleButton, femaleButton]).then
    {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.clipsToBounds = true
        $0.addCorner(rad: 10, borderColor: nil)        
    }
    
    var gender: UserGender = .unselected {
        didSet {
            switch gender {
            case .unselected:
                setButtonStatus(button: allGenderButton)
            case .male:
                setButtonStatus(button: maleButton)
            case .female:
                setButtonStatus(button: femaleButton)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewConfig() {
        gender = .unselected
        addSubview(buttonsStackView)
        buttonsStackView.backgroundColor = .systemBackground
        buttonsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding() {
        
    }
    
    private func setButtonStatus(button: UIButton) {
        button.backgroundColor = AssetsColors.green.color
        button.setTitleColor(AssetsColors.white.color, for: .normal)
    }
}
