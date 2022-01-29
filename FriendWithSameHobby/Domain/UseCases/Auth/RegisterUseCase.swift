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
    
    var maleButtonStatus = BehaviorRelay<Bool>(value: false)
    var femaleButtonStatus = BehaviorRelay<Bool>(value: false)
    
    var registerSuccess = PublishRelay<Bool>()
    var registerError = PublishRelay<UserRegisterError>()
    
    func execute() {
        let model = UserRegisterModel()
        userRepository?.registerUser(model: model, completion: { [weak self] result in
            switch result {
            case .success(let isRegistered):
                self?.registerSuccess.accept(isRegistered)
            case .failure(let error):
                self?.registerError.accept(error)
            }
        })
    }
    
    // 이런거는 UseCase를 거칠 필요가 있나..??? 없다고 결론나옴.
    func updateButtonStatus(gender: Int) {        
        switch gender {
        case 0:
            maleButtonStatus.accept(false)
            femaleButtonStatus.accept(!femaleButtonStatus.value)            
            UserInfoManager.gender = femaleButtonStatus.value ? gender : -1
        case 1:
            femaleButtonStatus.accept(false)
            maleButtonStatus.accept(!maleButtonStatus.value)
            UserInfoManager.gender = maleButtonStatus.value ? gender : -1
        default:
            break
        }
    }
}
