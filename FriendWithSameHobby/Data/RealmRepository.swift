//
//  RealmRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/19.
//

import Foundation
import RealmSwift

final class RealmRepository: RealmRepositoryInterface {
    let realm = try! Realm()
    
    init() {
        print(realm.configuration.fileURL)
    }
    
    func getLastChatDate(of otheruid: String) -> String? {
        guard let object = realm.object(ofType: RealmChatDTO.self,
                                        forPrimaryKey: otheruid) else { return nil }
        return object.payload.last?.createdAt
    }
    
    func saveChatHistory(of otheruid: String, with chatHistory: [ChatResponseModel]) {
        guard let object = realm.object(ofType: RealmChatDTO.self,
                                        forPrimaryKey: otheruid) else {
            let newUserChat = RealmChatDTO(otheruid: otheruid, chatHistory: chatHistory)
            
            do {
                try realm.write({
                    realm.add(newUserChat)
                })
            } catch {
                print(error)
            }
            return
        }
        
        //let prevHistory = Array(object.payload)
        let newHistory = List<RealmChatPayLoadDTO>()
        chatHistory.forEach {
            newHistory.append(RealmChatPayLoadDTO(model: $0))
        }        
        do {
            try realm.write {
                object.payload.append(objectsIn: newHistory)
            }
        } catch {
            print(error)
        }
    }
}
