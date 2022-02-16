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
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket is disconnected", data, ack)
        }
        
        socket.on("chat") { data, ack in
            print("chatchatchat")
        }
        
        socket.connect()
        print("socket config")
    }
}
