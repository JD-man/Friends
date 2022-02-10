//
//  ProfileGenderView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class ProfileGenderView: UIView {
    let titleLabel = UILabel().then {
        $0.text = "내 성별"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    let maleButton = BaseButton(title: "남자", status: .inactive, type: .h48)
    let femaleButton = BaseButton(title: "여자", status: .inactive, type: .h48)
    
    private var disposeBag = DisposeBag()
    
    var gender: UserGender = .unselected {
        didSet {
            switch gender {
            case .unselected:
                maleButton.status = .inactive
                femaleButton.status = .inactive
            case .female:
                maleButton.status = .inactive
                femaleButton.status = .fill
            case .male:
                maleButton.status = .fill
                femaleButton.status = .inactive
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
        [titleLabel, maleButton, femaleButton]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalTo(self)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.trailing.equalTo(self)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(femaleButton.frame.height)            
        }
        
        maleButton.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.trailing.equalTo(femaleButton.snp.leading).offset(-8)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(maleButton.frame.height)
        }
    }
    
    private func binding() {
        Observable.merge(
            maleButton.rx.tap.map { UserGender.male },
            femaleButton.rx.tap.map { UserGender.female })
            .asDriver(onErrorJustReturn: .unselected)
            .drive { [weak self] in
                self?.gender = $0
            }.disposed(by: disposeBag)
    }
}
