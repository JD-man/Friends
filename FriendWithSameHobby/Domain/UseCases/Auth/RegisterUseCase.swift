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
    var registerError = PublishRelay<UserAPIError>()
    
    func execute() {
        let model = UserRegisterModel()
        userRepository?.registerUser(model: model)
            .subscribe { [weak self] event in
                switch event {
                case .success(let response):
                    self?.registerSuccess.accept(response)
                    
                    // error test
                    // self?.registerError.accept(.unknownError)
                case .failure(let error):
                    // 공통 API Error로 캐스팅.
                    // rawvalue로 상태코드를 가져옴
                    // 그거를 여기에 알맞는 Error 변환후 accept                    
                    self?.registerError.accept(error as? UserAPIError ?? .unknownError)
                }
            }.disposed(by: disposeBag)
    }
    
    // 이런거는 UseCase를 거칠 필요가 있나..??? 없다고 결론나옴.
    func updateButtonStatus(gender: Int) {        
        switch gender {
        case 0:
            maleButtonStatus.accept(false)
            femaleButtonStatus.accept(!femaleButtonStatus.value)            
            UserDefaultsManager.gender = femaleButtonStatus.value ? gender : -1
        case 1:
            femaleButtonStatus.accept(false)
            maleButtonStatus.accept(!maleButtonStatus.value)
            UserDefaultsManager.gender = maleButtonStatus.value ? gender : -1
        default:
            break
        }
    }
}
