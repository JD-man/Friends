//
//  HobbyCollectionViewFlowLayout.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/08.
//

import UIKit

class HobbyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    convenience init(headerHeight: CGFloat) {
        self.init()
        scrollDirection = .vertical
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        headerReferenceSize = CGSize(width: collectionView?.frame.width ?? 0, height: headerHeight)
        sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        // 이거 있으면 가운데가 먼저나옴
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY = -1.0
        attributes?.forEach({
            if $0.representedElementKind == nil {
                if $0.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                $0.frame.origin.x = leftMargin
                leftMargin += $0.frame.width + 10
                maxY = max($0.frame.maxY, maxY)
            }
        })
        return attributes
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
