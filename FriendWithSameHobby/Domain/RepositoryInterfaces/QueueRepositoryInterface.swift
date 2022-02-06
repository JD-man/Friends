//
//  QueueRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/06.
//

import Foundation

protocol QueueRepositoryInterface {
    func requestOnqueue(model: OnqueueBodyModel,
                        completion: @escaping (Result<OnqueueResponseModel, OnqueueError>) -> Void)
}
