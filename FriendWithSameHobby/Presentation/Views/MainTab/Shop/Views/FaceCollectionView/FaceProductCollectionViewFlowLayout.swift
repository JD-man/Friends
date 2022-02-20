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
        scrollDirection = .vertical
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let width = (UIScreen.main.bounds.width / 2) - 30
        itemSize = CGSize(width: width, height: 400)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
