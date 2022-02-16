//
//  ProfileUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import Foundation
import RxRelay

final class ProfileUseCase: UseCaseType {
    var phoneAuthRepo: FirebaseAuthRepositoryInterface?
    var userRepo: UserRepositoryInterface?
    
    // withdraw relay
    let withdrawSuccess = PublishRelay<Bool>()
    let withdrawFail = PublishRelay<UserWithdrawError>()
    
    // fetch user page relay
    let userInfoData = PublishRelay<UserInfoModel>()
    let getUserInfoFail = PublishRelay<UserInfoError>()
    
    // update user page relay
    let updateSuccess = PublishRelay<Bool>()
    let updateFail = PublishRelay<UserMyPageError>()
    
    init(phoneAuthRepo: FirebaseAuthRepository, userRepo: UserRepositoryInterface?) {
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
                    self?.tokenErrorHandling { [weak self] in
                        self?.executeWithdraw()
                    }
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
                UserInfoManager.uid = model.uid
                UserInfoManager.nick = model.nick
                self?.userInfoData.accept(model)
            case .failure(let error):
                switch error {
                case .tokenError:
                    print("token error")
                    self?.tokenErrorHandling { [weak self] in
                        self?.executeFetchUserInfo()
                    }
                default:
                    self?.getUserInfoFail.accept(error)
                }
                
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
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling { [weak self] in
                        self?.excuteUpdateUserInfo(gender: gender,
                                                   hobby: hobby,
                                                   searchable: searchable,
                                                   ageMin: ageMin,
                                                   ageMax: ageMax)}
                default:
                    self?.updateFail.accept(error)
                }
                
            }
        })
    }
    
    private func tokenErrorHandling(completion: @escaping () -> Void) {
        phoneAuthRepo?.refreshingIDtoken(completion: { result in
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
