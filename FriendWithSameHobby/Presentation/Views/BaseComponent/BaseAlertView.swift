//
//  BaseAlertView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/05.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

enum BaseAlertMessage {
    case withdraw
    
    var title: String {
        switch self {
        case .withdraw:
            return "정말 탈퇴하시겠습니까?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .withdraw:
            return "탈퇴하시면 새싹 프렌즈를 이용할 수 업어요ㅋ"
        }
    }
}

final class BaseAlertView: UIView {
    
    deinit {
        print("Alert View Dismiss")
    }
    
    private let container = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.addCorner(rad: 10, borderColor: nil)
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 16)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    private let cancelButton = BaseButton(title: "취소", status: .cancel, type: .h48)
    private let confirmButton = BaseButton(title: "확인", status: .fill, type: .h48)
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(message: BaseAlertMessage, confirm: @escaping () -> Void) {
        self.init(frame: UIScreen.main.bounds)
        viewConfig(with: message)
        binding(confirm: confirm)
    }
    
    private func viewConfig(with message: BaseAlertMessage) {
        backgroundColor = AssetsColors.black.color.withAlphaComponent(0.5)
        [container, titleLabel, subtitleLabel, cancelButton, confirmButton]
            .forEach { addSubview($0) }
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(156)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top).offset(16)
            make.leading.trailing.equalTo(container).inset(16.5)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.height.equalTo(cancelButton.frame.height)
            make.trailing.equalTo(container.snp.centerX).offset(-4)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.trailing.equalTo(titleLabel)
            make.top.equalTo(cancelButton)
            make.height.equalTo(confirmButton.frame.height)
            make.leading.equalTo(container.snp.centerX).offset(4)
        }
        
        titleLabel.text = message.title
        subtitleLabel.text = message.subtitle
    }
    
    private func binding(confirm: @escaping () -> Void) {
        cancelButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.dismiss()
            }.disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .asDriver()
            .drive { _ in
                confirm()
            }.disposed(by: disposeBag)
    }
    
    func show() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.addSubview(self)
    }
    
    private func dismiss() {
        [container, titleLabel, subtitleLabel, cancelButton, confirmButton, self]
            .forEach { $0.removeFromSuperview() }        
    }
}
