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
    
    let shopInfoSuccess = PublishRelay<UserShopInfoModel>()
    let shopInfoFail = PublishRelay<UserShopError>()
    
    let updateImageSuccess = PublishRelay<Bool>()
    let updateImageFail = PublishRelay<UpdateImageError>()
    
    init(
        userRepo: UserRepositoryInterface,
        firebaseRepo: FirebaseAuthRepositoryInterface
    ) {
        self.userRepo = userRepo
        self.firebaseRepo = firebaseRepo
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
