//
//  NickNameViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class NickNameViewModel: ViewModelType {
    init(useCase: EmptyUseCase?, coordinator: AuthCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct Input {        
        // TextField Text
        let textFieldText: Driver<String>
        // Button Tap
        let nextButtonTap: Driver<String>
    }
    
    struct Output {
        // TextField Status
        let textFieldStatus = BehaviorRelay<BaseTextFieldStatus?>(value: .inactive)
        // Button Status
        let nextButtonStatus = BehaviorRelay<BaseButtonStatus>(value: .disable)
    }
    
    var useCase: EmptyUseCase?
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.textFieldText
            .map { (text) -> BaseButtonStatus in
                return text.count > 0 && text.count <= 10 ? .fill : .disable
            }.drive(output.nextButtonStatus)
            .disposed(by: disposeBag)
        
        input.textFieldText
            .map { (text) -> BaseTextFieldStatus? in
                return text.count > 10 ? .error(message: "10 글자 이내로 작성해주세요.") : nil                
            }.drive(output.textFieldStatus)
            .disposed(by: disposeBag)
        
        // Input To Coordinator && UserDefault nick save
        input.nextButtonTap
            .asDriver()
            .drive { [weak self] in
                switch output.nextButtonStatus.value {
                case .fill:
                    UserInfoManager.nick = $0
                    self?.coordinator?.pushBirthVC()
                default:
                    print("invalid nickname")
                }

            }.disposed(by: disposeBag)
        
        return output
    }
}
