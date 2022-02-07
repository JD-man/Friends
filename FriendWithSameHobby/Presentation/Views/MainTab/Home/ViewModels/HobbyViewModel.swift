//
//  HobbyViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class HobbyViewModel: ViewModelType {
    struct Input {
        // view will appear
        let viewWillAppear: Driver<Void>        
    }
    struct Output {
        let aroundTag = PublishRelay<[String]>()
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
        
        input.viewWillAppear
            .drive { [weak self] _ in
                self?.useCase?.executeRequestedHobby()
            }.disposed(by: disposeBag)
        
        return output
    }
}
