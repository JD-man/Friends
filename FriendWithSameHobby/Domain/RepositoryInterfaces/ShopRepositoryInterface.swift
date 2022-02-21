//
//  ShopRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/21.
//

import Foundation

protocol ShopRepositoryInterface {
    func buyProduct(
        localizedTitle: String,
        completion: @escaping (Result<(String, String), ShopError>) -> Void
    )
}
