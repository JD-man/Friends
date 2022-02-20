//
//  ShopViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

final class ShopViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private let viewModel: ShopViewModel
    
    private let backgroundImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.addCorner(rad: 8, borderColor: nil)
        $0.image = AssetsImages.sesacBackground1.image
    }
    
    private let faceImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = AssetsImages.sesacFace1.image
    }
    
    private let saveButton = BaseButton(title: "저장하기", status: .fill, type: .h40)
    private let faceTapButton = TopTabButton(title: "새싹", status: .selected)
    private let backgroundTapButton = TopTabButton(title: "배경", status: .unselected)
    
    private let backgroundProductTestRelay = BehaviorRelay<[BackgroundShopItemViewModel]>(
        value: [
            BackgroundShopItemViewModel(backgroundImage: SeSACBackground.basic,
                                        productName: "테스트 배경이름",
                                        isPurchased: true,
                                        description: "테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 "),
            BackgroundShopItemViewModel(backgroundImage: SeSACBackground.basic,
                                        productName: "테스트 배경이름",
                                        isPurchased: true,
                                        description: "테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 "),
            BackgroundShopItemViewModel(backgroundImage: SeSACBackground.basic,
                                        productName: "테스트 배경이름",
                                        isPurchased: true,
                                        description: "테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 "),
            BackgroundShopItemViewModel(backgroundImage: SeSACBackground.basic,
                                        productName: "테스트 배경이름",
                                        isPurchased: true,
                                        description: "테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 "),
            BackgroundShopItemViewModel(backgroundImage: SeSACBackground.basic,
                                        productName: "테스트 배경이름",
                                        isPurchased: true,
                                        description: "테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 테스트 설명 "),
        ])
    
    private let backgroundProductTableView = UITableView().then {
        $0.isHidden = true
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.register(BackgroundShopTableViewCell.self,
                    forCellReuseIdentifier: BackgroundShopTableViewCell.identifier)        
    }
    
    private let faceProductCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    weak var coordinator: ShopCoordinator?
    
    init(viewModel: ShopViewModel) {
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
        title = "새싹샵"
        view.backgroundColor = .systemBackground
        [backgroundImageView, faceImageView, saveButton,
         faceTapButton, backgroundTapButton, backgroundProductTableView].forEach { view.addSubview($0) }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(backgroundImageView.snp.width).multipliedBy(174.0 / 348.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(saveButton.frame.height)
            make.width.equalTo(saveButton.frame.height * 2)
            make.top.trailing.equalTo(backgroundImageView).inset(12)
        }
        
        faceImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.98)
            make.width.height.equalTo(184)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(20)
        }
        
        faceTapButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
            make.height.equalTo(44)
        }
        
        backgroundTapButton.snp.makeConstraints { make in
            make.top.width.height.equalTo(faceTapButton)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        backgroundProductTableView.snp.makeConstraints { make in
            make.top.equalTo(faceTapButton.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func binding() {
        // MARK: - Input Ouput
        let input = ShopViewModel.Input(
            faceShopButtonTap: faceTapButton.tabButton.rx.tap.asSignal(),
            bgShopButtonTap: backgroundTapButton.tabButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)

        output.shopHidden
            .map { $0 == true }
            .bind(to: backgroundProductTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.shopHidden
            .map { $0 == false ? TopTabButtonStatus.selected : TopTabButtonStatus.unselected }
            .bind(to: backgroundTapButton.rx.status)
            .disposed(by: disposeBag)
        
        output.shopHidden
            .map { $0 == true ? TopTabButtonStatus.selected : TopTabButtonStatus.unselected }
            .bind(to: faceTapButton.rx.status)
            .disposed(by: disposeBag)
        
//        output.shopHidden
//            .map { $0 == false }
//            .bind(to)
        
        // MARK: - TableView Binding
        backgroundProductTestRelay
            .asDriver(onErrorJustReturn: [])
            .drive(backgroundProductTableView.rx.items(
                cellIdentifier: BackgroundShopTableViewCell.identifier,
                cellType: BackgroundShopTableViewCell.self)) { row, item, cell in
                    cell.configure(with: item)
                }.disposed(by: disposeBag)
            
    }
}
