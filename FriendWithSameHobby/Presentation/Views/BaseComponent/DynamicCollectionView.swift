//
//  DynamicCollectionView.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/27.
//

import UIKit

final class DynamicCollectionView: UICollectionView {
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
