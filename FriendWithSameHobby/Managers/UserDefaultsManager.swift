//
//  UserDefaultsManager.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation

enum UserDefaultsKeyType: String {
    case idToken
    case phoneNumber
    case FCMtoken
    case nick
    case birth
    case email
    case gender
    case onboardingPassed
    case yearBirth
    case monthBirth
    case dayBirth
}

@propertyWrapper
struct UserDefaultsValue<T> {
    private var key: String
    
    var wrappedValue: T? {
        get { return UserDefaults.standard.value(forKey: self.key) as? T }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
    
    init(_ keyType: UserDefaultsKeyType) {
        self.key = keyType.rawValue
    }
}

struct UserDefaultsManager {
    @UserDefaultsValue(.idToken) static var idToken: String?
    @UserDefaultsValue(.phoneNumber) static var phoneNumber: String?
    @UserDefaultsValue(.FCMtoken) static var FCMtoken: String?
    @UserDefaultsValue(.nick) static var nick: String?
    @UserDefaultsValue(.birth) static var birth: String?
    @UserDefaultsValue(.email) static var email: String?
    @UserDefaultsValue(.gender) static var gender: Int?
    @UserDefaultsValue(.onboardingPassed) static var onboardingPassed: Bool?
    @UserDefaultsValue(.yearBirth) static var yearBirth: String?
    @UserDefaultsValue(.monthBirth) static var monthBirth: String?
    @UserDefaultsValue(.dayBirth) static var dayBirth: String?
}
