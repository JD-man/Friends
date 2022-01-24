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
                    UserDefaultsManager.phoneNumber = numText.removeHyphen()
                    single(.failure(PhoneAuthError.authFail))
                }            
            return Disposables.create()
        }
    }
    
    func verifyRegisterNumber(verificationCode: String, id: String) -> Single<String> {
        return Single<String>.create { single in
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: verificationCode)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    single(.failure(error))
                    print(error)
                    return
                }
                
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    guard let idToken = idToken else {
                        print("idToken Fail")
                        return
                    }
                    UserDefaultsManager.idToken = idToken
                    single(.success(idToken))
                })
            }
            return Disposables.create()
        }
    }
}
