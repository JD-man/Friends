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
        scrollDirection = .vertical
        minimumLineSpacing = 0
        minimumInteritemSpacing = 10
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
