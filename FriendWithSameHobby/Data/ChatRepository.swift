//
//  ChatRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation
import SocketIO
import RxRelay
import Moya

final class ChatRepository: ChatRepositoryInterface {
    
    // 매칭중단해서 맵뷰로 넘어갈때 socket이 nil이 됨..
    deinit {
        socket.disconnect()
    }
    
    typealias ChatSendResult = Result<ChatResponseModel, ChatSendError>
    typealias RequestChatHistoryResult = Result<[ChatResponseModel], RequestChatHistoryError>
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    private let provider = MoyaProvider<ChatTarget>()
    
    func sendMessage(model: ChatSendModel, completion: @escaping (ChatSendResult) -> Void) {        
        let parameters = ChatSendDTO(model: model).toParameters()
        provider.request(.send(uid: model.uid, parameters: parameters)) { result in
            switch result {
            case .success(let response):                
                guard let decoded = try? JSONDecoder().decode(ChatResponseDTO.self, from: response.data) else {
                    print("decode fail")
                    return
                }                
                completion(.success(decoded.toDomain()))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(ChatSendError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func requestChatHistory(otheruid: String, lastChatDate: String, completion: @escaping (RequestChatHistoryResult) -> Void ) {
        provider.request(.chatHistory(uid: otheruid, lastChatDate: lastChatDate)) { result in
            switch result {
            case .success(let response):
                guard let decoded = try? JSONDecoder().decode(ChatHistoryResponseDTO.self, from: response.data) else {
                    print("chat history decode fail")
                    return
                }                
                completion(.success(decoded.toDomain()))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(RequestChatHistoryError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
}

// MARK: - Socket Config
extension ChatRepository {
    func socketConfig(idToken: String, callback: @escaping (ChatResponseModel) -> Void) {
        let url = URL(string: URLComponents.baseURL)!
        manager = SocketManager(socketURL: url, config: [
            .compress])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("Socket is connected", data, ack)
            let uid = UserInfoManager.uid ?? ""
            self?.socket.emit("changesocketid", uid)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket is disconnected", data, ack)
        }
        
        socket.on("chat") { data, ack in
            guard let json = try? JSONSerialization.data(withJSONObject: data[0]),
                  let decoded = try? JSONDecoder().decode(ChatResponseDTO.self, from: json) else {
                print("decode fail")
                return
            }
            callback(decoded.toDomain())
        }
        
        socket.connect()
        // 자신의 uid를 같이 보낸다.
        print("socket config")
    }
}
