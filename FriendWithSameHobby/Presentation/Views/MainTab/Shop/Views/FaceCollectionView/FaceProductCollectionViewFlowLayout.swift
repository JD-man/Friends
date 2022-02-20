//
//  FaceCollectionViewFlowLayout.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/20.
//

import UIKit

class FaceProductCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        let spacing: CGFloat = 20
        let numberOfItem: CGFloat = 2
        let width = (UIScreen.main.bounds.width - ( (numberOfItem + 1) * spacing )) / numberOfItem
        
        sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        itemSize = CGSize(width: width, height: width * (279 / 165))
        
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
