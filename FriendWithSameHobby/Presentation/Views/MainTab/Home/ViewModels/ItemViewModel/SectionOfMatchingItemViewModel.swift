//
//  SectionOfCardViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/11.
//

import Foundation
import RxDataSources

struct MatchingItemViewModel: IdentifiableType, Equatable {
    var identity: String
    var sesac: SeSACFace
    var background: SeSACBackground
    var nick: String
    var reputation: [BaseButtonStatus] // BaseButtonStatus?
    var hf: [String]
    var review: [String]
    var matchingButtonStatus: MatchingButtonStatus
    var expanding: Bool
}

extension MatchingItemViewModel {
    static func testData() -> MatchingItemViewModel {
        return MatchingItemViewModel.init(
            identity: "uid",
            sesac: .basic,
            background: .basic,
            nick: "JD",
            reputation: [.fill, .fill, .inactive, .fill, .inactive, .fill],
            hf: ["취미1", "취미2"],
            review: ["리뷰1", "리뷰2"],
            matchingButtonStatus: .request,
            expanding: false
        )
    }
}

struct SectionOfMatchingItemViewModel {
    var items: [MatchingItemViewModel]
}

// TableView Using cardview always has one section
extension SectionOfMatchingItemViewModel: AnimatableSectionModelType {
    var identity: String {
        return "MatchingSection"
    }
    
    init(original: SectionOfMatchingItemViewModel, items: [MatchingItemViewModel]) {
        self = original
        self.items = items
    }
}

/*
 "uid": "x4r4tjQZ8Pf9mFYUgkfmC4REcvu2",
       "nick": "고래밥",
       "lat": 37.48511640269022,
       "long": 126.92947109241517,
       "reputation": [
         0,
         0,
         0,
         0,
         0,
         0,
         0,
         0,
         0
       ],
       "hf": [
         "anything",
         "Coding"
       ],
       "reviews": [
         "재밌었습니다",
         "약속을 잘지켜요!"
       ],
       "gender": 1,
       "type": 0,
       "sesac": 0,
       "background": 0
 */
