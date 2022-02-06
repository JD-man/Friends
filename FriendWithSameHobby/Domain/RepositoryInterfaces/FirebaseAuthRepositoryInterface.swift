//
//  PhoneAuthRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/29.
//

import Foundation

protocol FirebaseAuthRepositoryInterface {
    func verifyPhoneNumber(_ numText: String,
                           completion: @escaping (Result<String, UserInfoError>) -> Void)
    func retryPhoneNumber(completion: @escaping (Result<String, UserInfoError>) -> Void)
    func verifyRegisterNumber(verificationCode: String,                              
                              completion: @escaping (Result<String, UserInfoError>) -> Void)
    func refreshingIDtoken(completion: @escaping (Result<String, UserInfoError>) -> Void)
}
