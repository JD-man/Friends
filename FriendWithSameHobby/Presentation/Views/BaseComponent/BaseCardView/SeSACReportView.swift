//
//  SeSACReportView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/18.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SeSACReportView: UIView {
    
    private var disposeBag = DisposeBag()

    let titleLabel = UILabel().then {
        $0.text = ""
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }

    private let cheatingButton = BaseButton(title: "불법/사기", status: .inactive, type: .h32)
    private let uncomfortableButton = BaseButton(title: "불편한언행", status: .inactive, type: .h32)
    private let noshowButton = BaseButton(title: "노쇼", status: .inactive, type: .h32)
    private let sensitiveButton = BaseButton(title: "선정성", status: .inactive, type: .h32)
    private let personalButton = BaseButton(title: "인신공격", status: .inactive, type: .h32)
    private let etcButton = BaseButton(title: "기타", status: .inactive, type: .h32)

    private lazy var firstHStackView = UIStackView(arrangedSubviews: [
        cheatingButton, uncomfortableButton, noshowButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 16
        }
    private lazy var secondHStackView = UIStackView(arrangedSubviews: [
        sensitiveButton, personalButton, etcButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 16
        }
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [
        firstHStackView, secondHStackView]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 8
        }

    var reportedReputation: [BaseButtonStatus] {
        get {
            [cheatingButton, uncomfortableButton, noshowButton,
             sensitiveButton, personalButton, etcButton ].map { $0.status }
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
        [titleLabel, verticalStackView].forEach { addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(self)
        }
    }

    private func binding() {
        let buttons = [cheatingButton, uncomfortableButton, noshowButton,
                       sensitiveButton, personalButton, etcButton]
        
        buttons.forEach { button in
            button.rx.tap
                .asDriver()
                .drive { [weak button] _ in
                    button?.status = .fill
                }.disposed(by: disposeBag)
        }
    }
}
