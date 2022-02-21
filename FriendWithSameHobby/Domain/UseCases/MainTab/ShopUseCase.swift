//
//  ShopUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/20.
//

import Foundation
import RxRelay

final class ShopUseCase: UseCaseType {
    private let userRepo: UserRepositoryInterface
    private let firebaseRepo: FirebaseAuthRepositoryInterface
    private let shopRepo: ShopRepositoryInterface
    
    let shopInfoSuccess = PublishRelay<UserShopInfoModel>()
    let shopInfoFail = PublishRelay<UserShopError>()
    
    let updateImageSuccess = PublishRelay<Bool>()
    let updateImageFail = PublishRelay<UpdateImageError>()
    
    let inAppPurchaseFail = PublishRelay<ShopError>()
    let completePurchaseFail = PublishRelay<CompletePurchaseError>()
    
    init(
        userRepo: UserRepositoryInterface,
        firebaseRepo: FirebaseAuthRepositoryInterface,
        shopRepo: ShopRepositoryInterface
    ) {
        self.userRepo = userRepo
        self.firebaseRepo = firebaseRepo
        self.shopRepo = shopRepo
    }
    
    func executeGetShopInfo() {
        userRepo.shopInfo { [weak self] result in
            switch result {
            case .success(let model):
                self?.shopInfoSuccess.accept(model)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeGetShopInfo()
                    }
                default:
                    self?.shopInfoFail.accept(error)
                }
            }
        }
    }
    
    func executeSaveImageProfile(sesac: SeSACFace, bg: SeSACBackground) {
        let model = UpdateImageModel(sesac: sesac, background: bg)
        userRepo.saveImageProfile(model: model) { [weak self] result in
            switch result {
            case .success(let isSaved):
                self?.updateImageSuccess.accept(isSaved)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeSaveImageProfile(sesac: sesac, bg: bg)
                    }
                default:
                    self?.updateImageFail.accept(error)
                }
            }
        }
    }
    
    func executeBuyProduct(productName: String) {
        shopRepo.buyProduct(localizedTitle: productName) { [weak self] result in
            switch result {
            case .success(let purchaseResult):
                self?.executePostPurchaseResult(receipt: purchaseResult.0, product: purchaseResult.1)
            case .failure(let error):
                self?.inAppPurchaseFail.accept(error)
            }
        }
    }
    
    private func executePostPurchaseResult(receipt: String, product: String) {
        let model = CompletePurchaseModel(receipt: receipt, product: product)
        userRepo.completePurchase(model: model) { [weak self] result in
            switch result {
            case .success(_):
                self?.executeGetShopInfo()
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executePostPurchaseResult(receipt: receipt, product: product)
                    }
                default:
                    self?.completePurchaseFail.accept(error)
                }                
            }
        }
    }
    
    private func tokenErrorHandling(completion: @escaping () -> Void) {
        firebaseRepo.refreshingIDtoken(completion: { result in
            switch result {
            case .success(let idToken):
                UserInfoManager.idToken = idToken
                completion()
            case .failure(let error):
                print(error)
                break
            }
        })
    }
}
