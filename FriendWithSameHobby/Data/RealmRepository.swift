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
    
    func loadChat(of otheruid: String) -> [ChatResponseModel] {
        guard let object = realm.object(ofType: RealmChatDTO.self,
                                        forPrimaryKey: otheruid) else { return [] }
        return object.toDomain()
    }
}
