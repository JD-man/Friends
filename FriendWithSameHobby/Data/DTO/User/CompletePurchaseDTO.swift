//
//  CompletePurchaseDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/22.
//

import Foundation

struct CompletePurchaseDTO {
    let receipt: String
    let product: String
    
    init(model: CompletePurchaseModel) {
        self.receipt = model.receipt
        self.product = model.product
    }
}

extension CompletePurchaseDTO {
    func toParameters() -> Parameters {
        return [
            "receipt": receipt,
            "product": product
        ]
    }
}
