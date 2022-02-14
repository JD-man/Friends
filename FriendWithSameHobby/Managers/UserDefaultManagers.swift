//
//  UserDefaultsManager.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation

enum UserDefaultsKeyType: String {
    // User Info
    case idToken
    case phoneNumber
    case FCMtoken
    case nick
    case birth
    case email
    case gender
    case uid
    
    // User Progress
    case onboardingPassed
    case loggedIn
    case registered
    
    // Matching Status
    case matchingStatus
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

struct UserInfoManager {
    @UserDefaultsValue(.idToken) static var idToken: String?
    @UserDefaultsValue(.phoneNumber) static var phoneNumber: String?
    @UserDefaultsValue(.FCMtoken) static var fcmToken: String?
    @UserDefaultsValue(.nick) static var nick: String?
    @UserDefaultsValue(.birth) static var birth: Date?
    @UserDefaultsValue(.email) static var email: String?
    @UserDefaultsValue(.gender) static var gender: Int?
    @UserDefaultsValue(.uid) static var uid: String?
}

struct UserProgressManager {
    @UserDefaultsValue(.onboardingPassed) static var onboardingPassed: Bool?
    @UserDefaultsValue(.loggedIn) static var loggedIn: Bool?
    @UserDefaultsValue(.registered) static var registered: Bool?
}

struct UserMatchingStatus {
    @UserDefaultsValue(.matchingStatus) static var matchingStatus: String?
}
