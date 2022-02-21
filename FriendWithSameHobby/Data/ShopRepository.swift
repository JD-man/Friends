//
//  ShopRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/21.
//

import Foundation
import StoreKit

final class ShopRepository: NSObject, ShopRepositoryInterface {
    
    func buyProduct(productID: String) {
        //let payment = SKPayment(product: )
    }
    
    
}

extension ShopRepository {
    
    private func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(receiptString)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

extension ShopRepository: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    print("Transaction Approved.")
                    receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                case .failed:
                    print("Transaction Fail")
                    SKPaymentQueue.default().finishTransaction(transaction)
                @unknown default:
                    break
                }
            }
        }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print(#function)
    }
}
