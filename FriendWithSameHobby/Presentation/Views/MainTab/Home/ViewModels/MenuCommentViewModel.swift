//
//  MenuCommentViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class MenuCommentViewModel: ViewModelType {
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
    
    var useCase: MenuCommentUseCase
    weak var coordinator: HomeCoordinator?
    
    init(useCase: MenuCommentUseCase, coordinator: HomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input to usecase
        input.registerButtonTap
            .drive { [weak self] in
                if output.registerButtonStatus.value == BaseButtonStatus.fill {
                    self?.useCase.executeComment(reputation: $0.0, comment: $0.1)
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
        useCase.commentSuccess
            .asSignal()
            .emit { [weak self] _ in
                output.dismiss.accept(())
                self?.coordinator?.show(view: .mapView, by: .backToFirst)
            }.disposed(by: disposeBag)
        
        useCase.commentFail
            .asSignal()
            .emit { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        return output
    }
}
