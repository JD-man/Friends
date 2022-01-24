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
    struct Input {
        // TextField Begin Edit
        let textFieldEditBegin: Driver<Void>
        // TextField Text
        let textFieldText: Driver<String>
        // Button Tap
        let nextButtonTap: Driver<Void>
    }
    
    struct Output {
        // TextField Status
        let textFieldStatus = BehaviorRelay<BaseTextFieldStatus>(value: .inactive)
        // Button Status
        let nextButtonStatus = BehaviorRelay<BaseButtonStatus>(value: .disable)
        // text
        var textRelay = BehaviorRelay<String>(value: "")
    }
    
    var useCase: VerifyUseCase? = nil
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.textFieldText
            .drive {
                output.textRelay.accept($0)
                if $0.count > 0 && $0.count <= 10 {
                    print("why")
                    output.nextButtonStatus.accept(.fill)
                    output.textFieldStatus.accept(.focus)
                }
                else if $0.count > 10 {
                    output.nextButtonStatus.accept(.disable)
                    output.textFieldStatus.accept(.error(message: "10 글자 이내로 작성해주세요."))
                }
            }.disposed(by: disposeBag)
        
        // Input To Coordinator && UserDefault nick save
        
        return output
    }
}
