//
//  ProfileUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import Foundation
import RxRelay

final class ProfileUseCase: UseCaseType {
    var phoneAuthRepo: PhoneAuthRepository?
    var userRepo: UserRepositoryInterface?
    
    let withdrawSuccess = PublishRelay<Bool>()
    let withdrawFail = PublishRelay<UserWithdrawError>()
    
    let footerModel = PublishRelay<UserMyPageModel>()
    
    let getUserInfoFail = PublishRelay<UserInfoError>()
    
    init(phoneAuthRepo: PhoneAuthRepository, userRepo: UserRepositoryInterface?) {
        self.phoneAuthRepo = phoneAuthRepo
        self.userRepo = userRepo
    }
    
    func executeWithdraw() {
        userRepo?.withdrawUser(completion: { [weak self] result in
            switch result {
            case .success(let isWithdrawed):
                UserProgressManager.registered = nil
                self?.withdrawSuccess.accept(isWithdrawed)
            case .failure(let error):
                switch error {
                case .tokenError:
                    print("tokenError")
                    self?.tokenErrorHandling()
                default:
                    print(error)
                    self?.withdrawFail.accept(error)
                }            
            }
        })
    }
    
    func executeFetchUserInfo() {
        userRepo?.getUserInfo(completion: { [weak self] result in
            switch result {
            case .success(let model):
                let footerModel = UserMyPageModel(gender: UserGender(rawValue: model.gender) ?? .unselected,
                                                  hobby: model.hobby,
                                                  searchable: model.searchable == 1 ? true : false,
                                                  minAge: model.ageMin,
                                                  maxAge: model.ageMax)
                print(footerModel)
                self?.footerModel.accept(footerModel)
            case .failure(let error):
                self?.getUserInfoFail.accept(error)
            }
        })
    }
    
    func excuteUpdateUserInfo(gender: UserGender, hobby: String, searchable: Bool, ageMin: Int, ageMax: Int) {
        let model = UserMyPageModel(gender: gender,
                                    hobby: hobby,
                                    searchable: searchable,
                                    minAge: ageMin,
                                    maxAge: ageMax)
        // update user info
    }
    
    private func tokenErrorHandling() {
        phoneAuthRepo?.refreshingIDtoken(completion: { [weak self] result in
            switch result {
            case .success(let idToken):
                UserInfoManager.idToken = idToken
                print("new idtoken : ", UserInfoManager.idToken)
                self?.executeWithdraw()
            case .failure(_):
                self?.withdrawFail.accept(.unknownError)
            }
        })
    }
}
