//
//  MenuCommentView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/17.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class MenuCommentViewController: UIViewController {
    
    deinit {
        print("menu comment VC deinit")
    }
    
    private let viewModel: MenuCommentViewModel
    private var disposeBag = DisposeBag()
    
    private let container = UIView().then {
        $0.addCorner(rad: 20, borderColor: nil)
        $0.backgroundColor = .systemBackground
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(AssetsImages.closeBig.image, for: .normal)
    }
    private let titleLabel = UILabel().then {
        $0.text = "리뷰 등록"
        $0.textAlignment = .center
        $0.textColor = AssetsColors.black.color
        $0.font = AssetsFonts.NotoSansKR.medium.font(size: 14)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "OOO님과의 취미 활동은 어떠셨나요?"
        $0.textAlignment = .center
        $0.textColor = AssetsColors.green.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    
    private let hobbyStackView = SeSACTitleView().then {
        $0.titleLabel.text = ""
    }
    private let commentTextView = UITextView().then {
        $0.addCorner(rad: 8, borderColor: nil)
        $0.contentInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        $0.backgroundColor = AssetsColors.gray1.color
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
    private let registerButton = BaseButton(title: "리뷰 등록하기", status: .fill, type: .h48)
    
    init(viewModel: MenuCommentViewModel) {
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
        [closeButton, titleLabel, subtitleLabel, hobbyStackView, commentTextView, registerButton]
            .forEach { container.addSubview($0) }
        view.backgroundColor = AssetsColors.black.color.withAlphaComponent(0.25)
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.5)
            make.height.equalTo(container.snp.width).multipliedBy(450.0 / 343.0)
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
        
        hobbyStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(registerButton.frame.height)
            make.leading.bottom.trailing.equalToSuperview().inset(16)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(hobbyStackView)
            make.top.equalTo(hobbyStackView.snp.bottom).offset(24)
            make.bottom.equalTo(registerButton.snp.top).offset(-24)
        }
    }
    
    private func binding() {
        let input = MenuCommentViewModel.Input()
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        closeButton.rx.tap
            .asSignal()
            .emit { [weak self] _ in
                self?.dismiss(animated: false, completion: nil)
            }.disposed(by: disposeBag)
    }
}
