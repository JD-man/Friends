//
//  RegisterViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class RegisterViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
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
