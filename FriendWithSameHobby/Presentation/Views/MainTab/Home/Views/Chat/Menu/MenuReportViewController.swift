//
//  MenuReportViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/18.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxKeyboard
import RxGesture

class MenuReportViewController: UIViewController {
    
    private let viewModel: MenuReportViewModel
    private var disposeBag = DisposeBag()
    
    private let container = UIView().then {
        $0.addCorner(rad: 20, borderColor: nil)
        $0.backgroundColor = .systemBackground
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(AssetsImages.closeBig.image, for: .normal)
    }
    private let titleLabel = UILabel().then {
        $0.text = "새싹 신고"
        $0.textAlignment = .center
        $0.textColor = AssetsColors.black.color
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "다시는 해당 새싹과 매칭되지 않습니다"
        $0.textAlignment = .center
        $0.textColor = AssetsColors.green.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    private let reportStackView = SeSACReportView().then {
        $0.titleLabel.text = ""
    }
    private let commentTextView = UITextView().then {
        $0.addCorner(rad: 8, borderColor: nil)
        $0.textColor = AssetsColors.gray7.color
        $0.backgroundColor = AssetsColors.gray1.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
        $0.text = "신고 사유를 적어주세요\n허의 신고 시 제재를 받을 수 있습니다"
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    }
    
    private let registerButton = BaseButton(title: "신고하기", status: .fill, type: .h48)
    
    init(viewModel: MenuReportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {

        [closeButton, titleLabel, subtitleLabel, reportStackView, commentTextView, registerButton]
            .forEach { container.addSubview($0) }

        view.backgroundColor = AssetsColors.black.color.withAlphaComponent(0.25)
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.5)
            make.height.equalTo(container.snp.width).multipliedBy(400.0 / 343.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(17)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.top.trailing.equalToSuperview().inset(21)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        reportStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(registerButton.frame.height)
            make.leading.bottom.trailing.equalToSuperview().inset(16)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(reportStackView)
            make.top.equalTo(reportStackView.snp.bottom).offset(24)
            make.bottom.equalTo(registerButton.snp.top).offset(-24)
        }
    }
    
    private func binding() {
        let input = MenuReportViewModel.Input(
            registerButtonTap: registerButton.rx.tap.map { [weak self] in
                let reputation = self?.reportStackView.reportedReputation ?? []
                let comment = self?.commentTextView.text ?? ""
                return (reputation, comment)
            }.asDriver(onErrorJustReturn: ([], "")),
            commentText: commentTextView.rx.text.orEmpty.map { [weak self] in
                self?.commentTextView.textColor == AssetsColors.gray7.color ? "" : $0
            }.asDriver(onErrorJustReturn: ""),
            closeButtonTap: closeButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input, disposeBag: disposeBag)

        output.registerButtonStatus
            .asDriver()
            .drive(registerButton.rx.status)
            .disposed(by: disposeBag)

        output.dismiss
            .asSignal()
            .emit { [weak self] _ in
                print("dismiss")
                self?.dismiss(animated: false, completion: nil)
            }.disposed(by: disposeBag)

        commentTextView.rx.didBeginEditing
            .asDriver()
            .drive { [weak self] _ in
                self?.commentTextView.text = ""
                self?.commentTextView.textColor = AssetsColors.black.color
            }.disposed(by: disposeBag)

        RxKeyboard.instance.willShowVisibleHeight
            .drive { [weak self] in
                self?.view.frame.origin.y -= $0 * 0.5
            }.disposed(by: disposeBag)

        view.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.frame.origin.y = 0
                self?.commentTextViewConfig()
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    private func commentTextViewConfig() {
        if commentTextView.text.count == 0 {
            commentTextView.textColor = AssetsColors.gray7.color
            commentTextView.text = "신고 사유를 적어주세요\n허의 신고 시 제재를 받을 수 있습니다"
        }
    }
}
