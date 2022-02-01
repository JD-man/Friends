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
        let nextButtonTap: Driver<(BaseButtonStatus, String)>
    }
    
    struct Output {
        // TextField Status
        let textFieldStatus = BehaviorRelay<BaseTextFieldStatus>(value: .inactive)
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
            .map {
                if $0.count > 1 && $0.count <= 10 {
                    return .active                    
                } else if $0.count > 10 {
                    return .error(message: "10 글자 이내로 작성해주세요.")
                } else {
                    return .inactive
                }
            }.drive(output.textFieldStatus)
            .disposed(by: disposeBag)
        
        // Input To Coordinator && UserDefault nick save
        input.nextButtonTap
            .asDriver()
            .drive { [weak self] in
                let buttonStatus = $0.0
                let nick = $0.1
                switch buttonStatus {
                case .fill:
                    UserInfoManager.nick = nick
                    self?.coordinator?.pushBirthVC()
                default:
                    self?.coordinator?.toasting(message: "닉네임은 1자 이상 10자 이내로 부탁드려요.")
                }
            }.disposed(by: disposeBag)
        
        return output
    }
}
