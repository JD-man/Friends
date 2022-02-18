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
        let backButtonTap: Driver<Void>
        let moreButtonTap: Driver<Void>
        let viewWillAppear: Driver<Void>
        let sendButtonTap: Driver<String>
        let messageText: ControlProperty<String>
    }
    
    struct Output {
        // received message text
        let chatMessages = BehaviorRelay<[ChatItemViewModel]>(value: [])
        // text line limit
        let messageTextViewScrollEnabled = PublishRelay<Bool>()
        // text view initialize when send button tap
        let initializeTextView = PublishRelay<String>()
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
        
        input.viewWillAppear
            .drive { [weak self] _ in
                self?.useCase.executeSocketConnect()
            }.disposed(by: disposeBag)
        
        input.sendButtonTap
            .drive { [weak self] in
                print("sedn button tap")
                self?.useCase.executeSendMessage(chat: $0)
            }.disposed(by: disposeBag)
        
        input.sendButtonTap
            .map { _ in "" }
            .asSignal(onErrorJustReturn: "")
            .emit(to: output.initializeTextView)
            .disposed(by: disposeBag)
        
        // Input to Output
        input.messageText
            .map { $0.components(separatedBy: "\n").count > 2 }
            .bind(to: output.messageTextViewScrollEnabled)
            .disposed(by: disposeBag)
        
        // Input to Coordinator
        input.backButtonTap
            .asDriver()
            .drive { [weak self] _ in
                self?.coordinator?.show(view: .mapView, by: .backToFirst)
            }.disposed(by: disposeBag)
        
        input.moreButtonTap
            .asDriver()
            .drive { [weak self] _ in
                self?.coordinator?.presentChatMenuVC()
            }.disposed(by: disposeBag)
        
        // usecase to output        
        useCase.sendMessageSuccess
            .map { ChatItemViewModel(userType: .me, message: $0.chat, time: $0.createdAt) }
            .bind {
                var chatValue = output.chatMessages.value
                chatValue.append($0)
                output.chatMessages.accept(chatValue)
            }.disposed(by: disposeBag)
        
        useCase.receiveMessageSuccess
            .map { ChatItemViewModel(userType: .you, message: $0.chat, time: $0.createdAt) }
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
        
        useCase.checkMatchingFail
            .asSignal()
            .emit { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.coordinator?.show(view: .mapView, by: .backToFirst)
                }
            }.disposed(by: disposeBag)
        
        return output
    }
}
