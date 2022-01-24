//
//  EmailViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class EmailViewModel: ViewModelType {
    
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
    
    var useCase: VerifyUseCase? = nil
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }    
}
