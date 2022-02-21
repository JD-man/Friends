//
//  ShopRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/21.
//

import Foundation
import StoreKit

final class ShopRepository: NSObject, ShopRepositoryInterface {
    private var productDict: [String: SKProduct] = [:]
    
    private let faceProductIDs = Array(1 ... 4).map { "com.memolease.sesac1.sprout\($0)" }
    private let bgProductIDs = Array(1 ... 7).map { "com.memolease.sesac1.background\($0)" }
    
    var purchaseCompletion: ((Result<(String, String), ShopError>) -> Void)?
    
    override init() {
        super.init()
        let productIDs = Set(faceProductIDs + bgProductIDs)
        requestProductData(productIDs: productIDs)
    }
    
    func buyProduct(
        localizedTitle: String,
        completion: @escaping (Result<(String, String), ShopError>) -> Void
    ) {
        guard let product = productDict[localizedTitle] else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
        purchaseCompletion = completion
    }
}

// MARK: - Request Product List
extension ShopRepository: SKProductsRequestDelegate {
    private func requestProductData(productIDs: Set<String>) {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIDs)
            request.delegate = self
            request.start()
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if products.count > 0 {
            for product in products {
                productDict[product.localizedTitle] = product
            }
        }
        else {
            print("empty products")
        }        
    }
}

extension ShopRepository {
    private func receiptValidation(
        transaction: SKPaymentTransaction,
        productIdentifier: String) -> (String, String) {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        SKPaymentQueue.default().finishTransaction(transaction)
        return (receipt!, productIdentifier)
    }
}

extension ShopRepository: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    print("Transaction Approved.")
                    let result = receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                    purchaseCompletion?(.success(result))
                case .failed:
                    print("Transaction Fail")
                    purchaseCompletion?(.failure(.purchaseError))
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
