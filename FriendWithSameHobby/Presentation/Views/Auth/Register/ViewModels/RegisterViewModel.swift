//
//  RegisterViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class RegisterViewModel: ViewModelType {
    struct Input {
        
        // merged gender tap
        let mergedTap: Driver<Int>
        
        // male button tap
        //let maleTap: ControlEvent<Void>
        // female button tap
        //let femaleTap: ControlEvent<Void>
        
        // register button tap
        let registerTap: Driver<Void>
    }
    
    struct Output {
        // male button status
        let maleButtonColor = PublishRelay<UIColor>()
        // female button status
        let femaleButtonColor = PublishRelay<UIColor>()
    }
    
    var useCase: RegisterUseCase?
    weak var coordinator: AuthCoordinator?
    
    init(useCase: RegisterUseCase, coordinator: AuthCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        input.registerTap
            .drive { [unowned self] _ in                
                self.useCase?.execute()
            }.disposed(by: disposeBag)
        
        input.mergedTap
            .drive { [unowned self] in
                print($0)
                self.useCase?.updateButtonStatus(gender: $0)
            }.disposed(by: disposeBag)
        
        // Usecase to Output
        useCase?.maleButtonStatus
            .map { $0 ? AssetsColors.whiteGreen.color : .systemBackground}
            .bind(to: output.maleButtonColor)
            .disposed(by: disposeBag)
        
        useCase?.femaleButtonStatus
            .map { $0 ? AssetsColors.whiteGreen.color : .systemBackground}
            .bind(to: output.femaleButtonColor)
            .disposed(by: disposeBag)
                
        // UseCase to Coordinator
        return output
    }
}
