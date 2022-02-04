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
    
    private lazy var buttons = [allGenderButton, maleButton, femaleButton]
    
    private lazy var buttonsStackView = UIStackView(arrangedSubviews: buttons).then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.clipsToBounds = true
        $0.addCorner(rad: 10, borderColor: nil)        
    }
    
    var gender: UserGender = .unselected {
        didSet {
            switch gender {
            case .unselected:
                setButtonStatus(selectedButton: allGenderButton)
            case .male:
                setButtonStatus(selectedButton: maleButton)
            case .female:
                setButtonStatus(selectedButton: femaleButton)
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
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
        Observable.merge(
            allGenderButton.rx.tap.map { UserGender.unselected },
            maleButton.rx.tap.map { UserGender.male },
            femaleButton.rx.tap.map { UserGender.female })
            .asDriver(onErrorJustReturn: .unselected)
            .drive { [weak self] in
                self?.gender = $0
            }.disposed(by: disposeBag)
    }
    
    private func setButtonStatus(selectedButton: UIButton) {
        buttons.forEach {
            if $0 == selectedButton {
                $0.backgroundColor = AssetsColors.green.color
                $0.setTitleColor(AssetsColors.white.color, for: .normal)
            } else {
                $0.backgroundColor = AssetsColors.white.color
                $0.setTitleColor(AssetsColors.black.color, for: .normal)
            }
        }
    }
}
