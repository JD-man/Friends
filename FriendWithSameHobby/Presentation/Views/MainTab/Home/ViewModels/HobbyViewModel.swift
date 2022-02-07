//
//  HobbyViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/07.
//

import Foundation
import RxSwift

final class HobbyViewModel: ViewModelType {
    struct Input {
        
    }
    struct Output {
        
    }
    
    private var disposeBag = DisposeBag()
    var useCase: HobbyUseCase?
    weak var coordinator: HomeCoordinator?
    
    init(useCase: HobbyUseCase?, coordinator: HomeCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
