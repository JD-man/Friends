//
//  MenuReportViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/18.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

final class MenuReportViewModel: ViewModelType {
    struct Input {
        let registerButtonTap: Driver<([BaseButtonStatus], String)>
        let commentText: Driver<String>
        let closeButtonTap: Signal<Void>
    }
    
    struct Output {
        let registerButtonStatus = BehaviorRelay<BaseButtonStatus>(value: .disable)
        let isTextViewEmpty = PublishRelay<Bool>()
        let dismiss = PublishRelay<Void>()
    }
    
    var useCase: MenuReportUseCase
    weak var coordinator: HomeCoordinator?
    
    init(useCase: MenuReportUseCase, coordinator: HomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input to usecase
        input.registerButtonTap
            .drive { [weak self] in
                if output.registerButtonStatus.value == BaseButtonStatus.fill {
                    self?.useCase.executeReportUser(reported: $0.0, comment: $0.1)
                }
            }.disposed(by: disposeBag)
        
        input.commentText
            .map { $0.count == 0 || $0.count > 300 ? BaseButtonStatus.disable : BaseButtonStatus.fill }
            .asSignal(onErrorJustReturn: .disable)
            .emit(to: output.registerButtonStatus)
            .disposed(by: disposeBag)
        
        input.closeButtonTap
            .emit(to: output.dismiss)
            .disposed(by: disposeBag)
        
        // usecase to coordinator
        useCase.reportSuccess
            .asSignal()
            .emit { [weak self] _ in
                output.dismiss.accept(())
                self?.coordinator?.show(view: .mapView, by: .backToFirst)
            }.disposed(by: disposeBag)
        
        useCase.reportFailure
            .asSignal()
            .emit { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        return output
    }
}
