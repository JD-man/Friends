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
    case matchingRequest
    case matchingAllow
    case dodgeMatching
    case locationAuth
    
    var title: String {
        switch self {
        case .withdraw:
            return "정말 탈퇴하시겠습니까?"
        case .matchingRequest:
            return "취미 같이 하기를 요청할게요!"
        case .matchingAllow:
            return "취미 같이 하기를 수락할까요?"
        case .dodgeMatching:
            return "약속을 취소하시겠습니까?"
        case .locationAuth:
            return "위치 서비스 사용 불가"
        }
    }
    
    var subtitle: String {
        switch self {
        case .withdraw:
            return "탈퇴하시면 새싹 프렌즈를 이용할 수 업어요ㅋ"
        case .matchingRequest:
            return "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요"
        case .matchingAllow:
            return "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        case .dodgeMatching:
            return "약속을 취소하시면 페널티가 부과됩니다"
        case .locationAuth:
            return "위치 서비스 사용을 위해서 권한 설정이 필요합니다."
        }
    }
}

final class BaseAlertView: UIView {
    
    deinit {
        print("Alert View deinit")
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
            .drive { [weak self] _ in
                confirm()
                self?.dismiss()
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
