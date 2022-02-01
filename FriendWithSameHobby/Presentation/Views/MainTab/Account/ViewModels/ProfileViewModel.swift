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
        // viewWillAppear
        let viewWillAppear: Driver<Void>
        // withdraw button tap
        let withdrawTap: ControlEvent<Void>
    }
    
    struct Output {
        // viewWillAppear Test
        let viewWillAppear = PublishRelay<String>()
        
        let gender = PublishRelay<UserGender>()
        let hobby = PublishRelay<String>()
        let searchable = PublishRelay<Bool>()
        let minAgeIndex = PublishRelay<Int>()
        let maxAgeIndex = PublishRelay<Int>()
        let ageRange = PublishRelay<String>()
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
                self?.useCase?.executeWithdraw()
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .drive { [weak self] _ in
                self?.useCase?.executeFetchUserInfo()
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
        
        // Usecase to Output
        useCase?.footerModel
            .map { $0.gender }
            .bind(to: output.gender)
            .disposed(by: disposeBag)
        
        useCase?.footerModel
            .map { $0.hobby }
            .bind(to: output.hobby)
            .disposed(by: disposeBag)
        
        useCase?.footerModel
            .map { $0.searchable }
            .bind(to: output.searchable)
            .disposed(by: disposeBag)
        
        useCase?.footerModel
            .map { $0.minAge - 18 }
            .bind(to: output.minAgeIndex)
            .disposed(by: disposeBag)
        
        useCase?.footerModel
            .map { $0.maxAge - 18 }
            .bind(to: output.maxAgeIndex)
            .disposed(by: disposeBag)
        
        useCase?.footerModel
            .map { "\($0.minAge)-\($0.maxAge)" }
            .bind(to: output.ageRange)
            .disposed(by: disposeBag)
        
        return output
    }
}
