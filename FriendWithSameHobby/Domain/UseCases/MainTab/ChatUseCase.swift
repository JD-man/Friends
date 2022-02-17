//
//  ChatUserCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation
import RxRelay

final class ChatUseCase: UseCaseType {
    private let firebaseRepo: FirebaseAuthRepositoryInterface
    private let queueRepo: QueueRepositoryInterface
    private let chatRepo: ChatRepositoryInterface
    // realmRepo
    
    let sendMessageSuccess = PublishRelay<ChatResponseModel>()
    let sendMessageFail = PublishRelay<ChatSendError>()
    
    let checkMatchingFail = PublishRelay<CheckMatchingError>()
    
    let receiveMessageSuccess = PublishRelay<ChatResponseModel>()
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        queueRepo: QueueRepositoryInterface,
        chatRepo: ChatRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.queueRepo = queueRepo
        self.chatRepo = chatRepo
    }
    
    func executeSocketConnect() {
        let model = MatchingBodyModel(uid: UserInfoManager.uid ?? "")
        queueRepo.checkMatchingStatus(model: model, completion: { [weak self] result in
            switch result {
            case .success(let model):
                UserChatManager.otherUID = model.matchedUid
                UserChatManager.otherNickname = model.matchedNick
                print(model)
                // socket connect
                let idtoken = UserInfoManager.idToken ?? ""
                self?.chatRepo.socketConfig(idToken: idtoken, callback: {
                    self?.receiveMessageSuccess.accept($0)
                })
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeSocketConnect()
                    }
                default:
                    UserChatManager.otherUID = nil
                    UserChatManager.otherNickname = nil
                    UserMatchingStatus.matchingStatus = MatchingStatus.normal.rawValue
                    self?.checkMatchingFail.accept(error)
                }
            }
        })
    }
    
    func executeSendMessage(chat: String) {
        let uid = UserChatManager.otherUID ?? ""
        print(uid)
        let model = ChatSendModel(uid: uid, chat: chat)
        chatRepo.sendMessage(model: model) { [weak self] result in
            switch result {
            case .success(let model):
                self?.sendMessageSuccess.accept(model)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeSendMessage(chat: chat)
                    }
                default:
                    self?.sendMessageFail.accept(error)
                }
            }
        }
    }
    
    private func tokenErrorHandling(completion: @escaping () -> Void) {
        firebaseRepo.refreshingIDtoken(completion: { result in
            switch result {
            case .success(let idToken):
                UserInfoManager.idToken = idToken
                completion()
            case .failure(let error):
                print(error)
                break
            }
        })
    }
}
