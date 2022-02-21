//
//  BackgroundShopItemViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/20.
//

import Foundation

struct BackgroundShopItemViewModel {
    let price: String
    let backgroundImage: SeSACBackground
    let productName: String
    let isPurchased: Bool
    let description: String
}

extension BackgroundShopItemViewModel {
    static func products(bgCollection: [SeSACBackground] ) -> [BackgroundShopItemViewModel] {
        SeSACBackground.allCases.map {
            return BackgroundShopItemViewModel(price: $0.price.formattedNumber,
                                               backgroundImage: $0,
                                               productName: $0.productName,
                                               isPurchased: bgCollection.contains($0) ? true : false,
                                               description: $0.description)
        }
    }
}
