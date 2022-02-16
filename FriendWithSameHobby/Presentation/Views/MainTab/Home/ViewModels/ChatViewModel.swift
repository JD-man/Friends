//
//  ChatViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class ChatViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Driver<Void>
        let sendButtonTap: Driver<String>
        let messageText: ControlProperty<String>
    }
    
    struct Output {
        // received message text
        let chatMessages = BehaviorRelay<[ChatItemViewModel]>(value: [])
        // text line limit
        let messageTextViewScrollEnabled = PublishRelay<Bool>()
    }
    
    var useCase: ChatUseCase
    weak var coordinator: HomeCoordinator?
    
    init(useCase: ChatUseCase, coordinator: HomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        
//        input.viewWillAppear
//            .drive { [weak self] _ in
//                self?.useCase.executeSocketConnect()
//            }.disposed(by: disposeBag)
        
        input.sendButtonTap
            .drive { [weak self] in
                self?.useCase.executeSendMessage(chat: $0)
            }.disposed(by: disposeBag)
        
        // Input to Output
        input.messageText
            .map { $0.components(separatedBy: "\n").count > 3 }
            .bind(to: output.messageTextViewScrollEnabled)
            .disposed(by: disposeBag)
        
        // usecase to output        
        useCase.sendMessageSuccess
            .map { ChatItemViewModel(userType: .me, message: $0.chat, time: $0.createdAt.chatDate) }
            .bind {
                var chatValue = output.chatMessages.value
                chatValue.append($0)
                output.chatMessages.accept(chatValue)
            }.disposed(by: disposeBag)
        
        useCase.sendMessageFail
            .asSignal()
            .emit { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        return output
    }
}
