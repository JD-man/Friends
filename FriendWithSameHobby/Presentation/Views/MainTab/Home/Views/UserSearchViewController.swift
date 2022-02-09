//
//  UserSearchViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/09.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

class UserSearchViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let changeHobbyButton = BaseButton(title: "취미 변경하기", status: .fill, type: .h48)
    private let refreshButton = UIButton().then {
        $0.setImage(AssetsImages.clarityRefreshLine.image, for: .normal)
        $0.addCorner(rad: 8, borderColor: AssetsColors.green.color)
    }
    
    private let backButton = UIBarButtonItem().then {
        $0.image = AssetsImages.arrow.image
    }
    private let stopMatchingButton = UIBarButtonItem().then {
        $0.title = "찾기중단"
        $0.setTitleTextAttributes([.font : AssetsFonts.NotoSansKR.medium.font(size: 14)], for: .normal)
    }
    
    private var viewModel: UserSearchViewModel
    
    init(viewModel: UserSearchViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "새싹 찾기"
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [changeHobbyButton, refreshButton]
            .forEach { view.addSubview($0) }
        refreshButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        changeHobbyButton.snp.makeConstraints { make in
            make.bottom.height.equalTo(refreshButton)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-8)
        }
        
        // nav config
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopMatchingButton
    }
    
    private func binding() {
        let input = UserSearchViewModel.Input(
            backButtonTap: backButton.rx.tap.asDriver(),
            stopMatchingButtonTap: stopMatchingButton.rx.tap.asDriver(),
            changeHobbyButtonTap: changeHobbyButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
    }
}
