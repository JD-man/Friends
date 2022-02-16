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
    typealias ChatSendResult = Result<ChatResponseModel, ChatSendError>
    
    private var manager: SocketManager!
    private lazy var socket: SocketIOClient = manager.defaultSocket
    
    let receivedMessage = PublishRelay<ChatResponseModel>()
    
    deinit {
        socket.disconnect()
    }
    
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
            //.log(true),
            .compress,
            .extraHeaders(["auth" : idToken])
            ])
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket is disconnected", data, ack)
        }
        
        socket.on("chat") { dataArr, ack in
            print("received chat", dataArr, ack)
//            let data = dataArr[0] as! NSDictionary
//            let chat = data["text"] as! String
//            let name = data["name"] as! String
//            let createAt = data["createdAt"] as! String
            
            //print("chat check", chat, name, createAt)
            
            
//            let receivedChat = ChatResponseModel(to: <#T##String#>, from: <#T##String#>, chat: <#T##String#>, createdAt: <#T##Date#>)
//            receivedMessage.accept(receivedChat)
        }
        
        socket.connect()
    }
}
