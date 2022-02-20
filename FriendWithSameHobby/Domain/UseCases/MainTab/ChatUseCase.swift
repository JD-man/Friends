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
    private let realmPepo: RealmRepositoryInterface
    
    let sendMessageSuccess = PublishRelay<ChatResponseModel>()
    let sendMessageFail = PublishRelay<ChatSendError>()
    
    let checkMatchingFail = PublishRelay<CheckMatchingError>()
    
    let receiveMessageSuccess = PublishRelay<[ChatResponseModel]>()
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        queueRepo: QueueRepositoryInterface,
        chatRepo: ChatRepositoryInterface,
        realmRepo: RealmRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.queueRepo = queueRepo
        self.chatRepo = chatRepo
        self.realmPepo = realmRepo
    }
    
    // 매칭 상태 요청 -> 채팅 DB 최근날짜 가져오기 -> 최근 채팅 내역 요청 -> DB 저장 -> 소켓 시작 -> 채팅 뷰모델로
    
    func executeSocketConnect() {
        let model = MatchingBodyModel(uid: UserInfoManager.uid ?? "")
        queueRepo.checkMatchingStatus(model: model, completion: { [weak self] result in
            switch result {
            case .success(let model):
                guard let self = self else { return }
                UserChatManager.otherUID = model.matchedUid
                UserChatManager.otherNickname = model.matchedNick
                
                // lastChatDate
                let lastChatDate = self.executeLoadChat(otheruid: model.matchedUid ?? "")
                print("last chat date: ", lastChatDate)
                // request chat history, save chat
                self.executeRequestChatHistory(otheruid: model.matchedUid ?? "", lastChatDate: lastChatDate)
                
                // socket connect
                let idtoken = UserInfoManager.idToken ?? ""
                self.chatRepo.socketConfig(idToken: idtoken, callback: {
                    self.realmPepo.saveChatHistory(of: model.matchedUid ?? "" , with: [$0])
                    self.receiveMessageSuccess.accept([$0])
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
    
    private func executeLoadChat(otheruid: String) -> String {
        return realmPepo.getLastChatDate(of: otheruid) ?? "2000-01-01T00:00:00.000Z"
    }
    
    private func executeRequestChatHistory(otheruid: String, lastChatDate: String) {
        chatRepo.requestChatHistory(otheruid: otheruid, lastChatDate: lastChatDate) { [weak self] result in
            switch result {
            case .success(let chatHistory):
                self?.realmPepo.saveChatHistory(of: otheruid, with: chatHistory)
                let chat = self?.realmPepo.loadChat(otheruid: otheruid) ?? []
                self?.receiveMessageSuccess.accept(chat)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeRequestChatHistory(otheruid: otheruid, lastChatDate: lastChatDate)
                    }
                default:
                    print("load chat history error", error)
                }
            }
        }
    }
    
    func executeSendMessage(chat: String) {
        let otheruid = UserChatManager.otherUID ?? ""        
        let model = ChatSendModel(uid: otheruid, chat: chat)
        chatRepo.sendMessage(model: model) { [weak self] result in
            switch result {
            case .success(let model):
                self?.realmPepo.saveChatHistory(of: otheruid, with: [model])
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
