//
//  ProfileViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class ProfileViewModel: ViewModelType {
    struct Input {
        // withdraw button tap
        let withdrawTap: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    var useCase: ProfileUseCase?
    weak var coordinator: AccountCoordinator?
    private var disposeBag = DisposeBag()
    
    init(useCase: ProfileUseCase?, coordinator: AccountCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input to usecase
        input.withdrawTap
            .asDriver()
            .drive { [weak self] _ in
                self?.useCase?.execute()
            }.disposed(by: disposeBag)
        
        // usecase to coordinator
        useCase?.withdrawSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                guard let mainTabCoordinator = self?.coordinator?.parentCoordinator as? MainTabCoordinator else {
                    return
                }
                mainTabCoordinator.finish(to: .auth) {
                    print("withdraw success")
                }
            }.disposed(by: disposeBag)
        
        return output
    }
}
