//
//  SeSACHobbyTagView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//
import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

final class SeSACHobbyTagView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "하고 싶은 취미"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    private let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: HobbyCollectionViewFlowLayout(headerHeight: 0)).then {
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        $0.isScrollEnabled = false
        $0.register(HobbyCollectionViewCell.self, forCellWithReuseIdentifier: HobbyCollectionViewCell.identifier)
    }
    var hobbyTagRelay = BehaviorRelay<[String]>(value: ["테스트태그", "테스트태그", "테스트태그", "테스트태그"])
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
        [titleLabel, tagCollectionView]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(50).priority(.low)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        tagCollectionView.snp.updateConstraints { make in
            make.height.equalTo(tagCollectionView.collectionViewLayout.collectionViewContentSize.height)
                .priority(.low)
        }
    }
    
    private func binding() {
        hobbyTagRelay
            .asDriver()
            .drive(tagCollectionView.rx.items(
                cellIdentifier: HobbyCollectionViewCell.identifier,
                cellType: HobbyCollectionViewCell.self)) { row, item, cell in
                    cell.emptyLabel.text = item
                    cell.tagButton.status = .inactive
                    cell.tagButton.setTitle(item, for: .normal)
                }.disposed(by: disposeBag)
    }
}
