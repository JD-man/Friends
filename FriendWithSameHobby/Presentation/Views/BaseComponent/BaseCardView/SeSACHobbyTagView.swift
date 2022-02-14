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

class DynamicCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}

final class SeSACHobbyTagView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "하고 싶은 취미"
        $0.font = AssetsFonts.NotoSansKR.regular.font(size: 12)
    }
    
    private let tagCollectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: HobbyCollectionViewFlowLayout(headerHeight: 0)).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.register(HobbyCollectionViewCell.self, forCellWithReuseIdentifier: HobbyCollectionViewCell.identifier)
    }
    var hobbyTagRelay = BehaviorRelay<[String]>(value: [])
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.bottom.equalToSuperview().priority(.low)
        }
    }
}
