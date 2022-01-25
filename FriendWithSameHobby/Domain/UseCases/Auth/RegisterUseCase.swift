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
    
    var maleButtonStatus = PublishRelay<Bool>()
    var femaleButtonStatus = PublishRelay<Bool>()
    
    func execute() {
        userRepository?.registerUser()
            .subscribe { event in
                switch event {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    // 공통 API Error로 캐스팅.
                    // rawvalue로 상태코드를 가져옴
                    // 그거를 여기에 알맞는 Error 변환후 accept
                    print(error as? UserAPIError)
                }
            }.disposed(by: disposeBag)
    }
    
    // 이런거는 UseCase를 거칠 필요가 있나..???
    func updateButtonStatus(gender: Int) {        
        switch gender {
        case 0:
            femaleButtonStatus.accept(true)
            maleButtonStatus.accept(false)
        case 1:
            femaleButtonStatus.accept(false)
            maleButtonStatus.accept(true)
        default:
            break
        }
        // 이런게 들어가있으니까..??
        UserDefaultsManager.gender = gender
    }
}
