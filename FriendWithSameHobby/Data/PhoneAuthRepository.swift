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

final class PhoneAuthRepository: PhoneAuthRepositoryInterface {
    var phoneID: String?
    init(phoneID: String?) {
        self.phoneID = phoneID
    }
    
    func verifyPhoneNumber(_ numText: String,
                           completion: @escaping (Result<String, UserInfoError>) -> Void) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(numText, uiDelegate: nil) { id, error in
                if let error = error {
                    let statusCode = AuthErrorCode(rawValue: (error as NSError).code)?.rawValue ?? -1
                    print(statusCode)
                    completion(.failure(UserInfoError(rawValue: statusCode) ?? .unknownError))
                    return
                }
                guard let id = id else { return }                
                completion(.success(id))
            }
    }
    
    func verifyRegisterNumber(verificationCode: String,                              
                              completion: @escaping (Result<String, UserInfoError>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: phoneID ?? "",
                                                                 verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                let statusCode = AuthErrorCode(rawValue: (error as NSError).code)?.rawValue ?? -1
                print(statusCode)
                completion(.failure(UserInfoError(rawValue: statusCode) ?? .unknownError))
            }
            else {
                self?.refreshingIDtoken(completion: completion)
            }
        }
    }
    
    func retryPhoneNumber(completion: @escaping (Result<String, UserInfoError>) -> Void) {
        let phoneNumber = UserInfoManager.phoneNumber ?? ""
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] id, error in
                if let error = error {
                    let statusCode = AuthErrorCode(rawValue: (error as NSError).code)?.rawValue ?? -1
                    print(statusCode)
                    completion(.failure(UserInfoError(rawValue: statusCode) ?? .unknownError))
                    return
                }
                guard let id = id else { return }
                self?.phoneID = id
                completion(.success(id))
            }
    }
    
    func refreshingIDtoken(completion: @escaping (Result<String, UserInfoError>) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
            if let error = error {
                let statusCode = AuthErrorCode(rawValue: (error as NSError).code)?.rawValue ?? -1
                print(statusCode)
                completion(.failure(UserInfoError(rawValue: statusCode) ?? .unknownError))
            }
            guard let idToken = idToken else {
                return
            }                        
            completion(.success(idToken))
        })
    }
}
