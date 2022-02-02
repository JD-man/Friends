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
    
    // withdraw relay
    let withdrawSuccess = PublishRelay<Bool>()
    let withdrawFail = PublishRelay<UserWithdrawError>()
    
    // fetch user page relay
    let userInfoData = PublishRelay<UserMyPageModel>()
    let getUserInfoFail = PublishRelay<UserInfoError>()
    
    // update user page relay
    let updateSuccess = PublishRelay<Bool>()
    let updateFail = PublishRelay<UserMyPageError>()
    
    init(phoneAuthRepo: PhoneAuthRepository, userRepo: UserRepositoryInterface?) {
        self.phoneAuthRepo = phoneAuthRepo
        self.userRepo = userRepo
    }
    
    func executeWithdraw() {
        userRepo?.withdrawUser(completion: { [weak self] result in
            switch result {
            case .success(let isWithdrawed):
                UserProgressManager.loggedIn = nil
                UserProgressManager.registered = nil
                UserProgressManager.onboardingPassed = nil
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
                self?.userInfoData.accept(footerModel)
            case .failure(let error):
                print(error)
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
        userRepo?.updateUserMyPage(model: model, completion: { [weak self] result in
            switch result {
            case .success(let isUpdated):
                self?.updateSuccess.accept(isUpdated)
            case .failure(let error):
                self?.updateFail.accept(error)
            }
        })
    }
    
    private func tokenErrorHandling() {
        phoneAuthRepo?.refreshingIDtoken(completion: { [weak self] result in
            switch result {
            case .success(let idToken):
                UserInfoManager.idToken = idToken                
                self?.executeWithdraw()
            case .failure(_):
                self?.withdrawFail.accept(.unknownError)
            }
        })
    }
}
