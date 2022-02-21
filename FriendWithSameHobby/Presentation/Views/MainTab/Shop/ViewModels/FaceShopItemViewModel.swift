//
//  FaceShopItemViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/20.
//

import Foundation

struct FaceShopItemViewModel {
    let price: String
    let faceImage: SeSACFace
    let productName: String
    let isPurchased: Bool
    let description: String
}

extension FaceShopItemViewModel {
    static func products(sesacCollection: [SeSACFace] ) -> [FaceShopItemViewModel] {
        SeSACFace.allCases.map {
            return FaceShopItemViewModel(price: $0.price.formattedNumber,
                                         faceImage: $0,
                                         productName: $0.productName,
                                         isPurchased: sesacCollection.contains($0) ? true : false,
                                         description: $0.description)
        }
    }
}
