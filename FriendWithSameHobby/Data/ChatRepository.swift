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
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    let receivedMessage = PublishRelay<ChatResponseModel>()
    
    private let provider = MoyaProvider<ChatTarget>()
    
    func sendMessage(model: ChatSendModel, completion: @escaping (ChatSendResult) -> Void) {        
        let parameters = ChatSendDTO(model: model).toParameters()
        provider.request(.send(uid: model.uid, parameters: parameters)) { result in
            switch result {
            case .success(let response):
                guard let decoded = try? JSONDecoder().decode(ChatResponseDTO.self, from: response.data) else {
                    return
                }                
                completion(.success(decoded.toDomain()))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(ChatSendError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
}

// MARK: - Socket Config
extension ChatRepository {
    func socketConfig(idToken: String) {        
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
        
        socket.on("chat") { [weak self] data, ack in
            guard let data = data[0] as? NSDictionary,
                  let v = data["__v"] as? Int,
                  let id = data["__id"] as? String,
                  let chat = data["chat"] as? String,
                  let to = data["to"] as? String,
                  let from = data["from"] as? String,
                  let createdAt = data["createdAt"] as? String else {
                      print("chat decode fail")
                      return
                  }
            
            let dto = ChatResponseDTO(id: id,
                                      v: v,
                                      to: to,
                                      from: from,
                                      chat: chat,
                                      createdAt: createdAt)
            
            self?.receivedMessage.accept(dto.toDomain())
        }
        
        socket.connect()
        // 자신의 uid를 같이 보낸다.
        print("socket config")
    }
}
