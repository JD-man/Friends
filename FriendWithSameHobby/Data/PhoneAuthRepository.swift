//
//  PhoneAuthRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/22.
//

import Foundation
import RxSwift
import FirebaseAuth

enum PhoneAuthError: Error {
    case authFail
    case notFillButton
}

final class PhoneAuthRepository {
    func verifyPhoneNumber(_ numText: String) -> Single<String> {
        return Single<String>.create { single in
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(numText, uiDelegate: nil) { id, error in
                    if let error = error {
                        single(.failure(error))
                        print(error)
                        return
                    }
                    guard let id = id else {
                        print("phone auth id is nil")
                        return
                    }
                    single(.success(id))
                }            
            return Disposables.create()
        }
    }
}
