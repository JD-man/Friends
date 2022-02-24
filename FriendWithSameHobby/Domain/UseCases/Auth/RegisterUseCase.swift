//
//  RegisterUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class RegisterUseCase: UseCaseType {
    var userRepository: UserRepositoryInterface?
    init(userRepository: UserRepositoryInterface) {
        self.userRepository = userRepository
    }
    
    private var disposeBag = DisposeBag()
    
    var registerSuccess = PublishRelay<Bool>()
    var registerError = PublishRelay<UserRegisterError>()
    
    func executeRegister(gender: UserGender) {
        UserInfoManager.gender = gender.rawValue
        let model = UserRegisterModel()
        userRepository?.registerUser(model: model, completion: { [weak self] result in
            switch result {
            case .success(let isRegistered):
                UserProgressManager.registered = true
                self?.registerSuccess.accept(isRegistered)
            case .failure(let error):
                self?.registerError.accept(error)
            }
        })
    }
}
