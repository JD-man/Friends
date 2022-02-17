//
//  MenuCommentViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/17.
//

import Foundation
import RxSwift
import RxCocoa

final class MenuCommentViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var useCase: MenuCommentUseCase
    weak var coordinator: HomeCoordinator?
    
    init(useCase: MenuCommentUseCase, coordinator: HomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
