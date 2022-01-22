//
//  PhoneAuthViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class PhoneAuthViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var useCase = PhoneAuthUseCase()
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}
