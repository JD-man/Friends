//
//  SectionOfHobbyCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/08.
//

import Foundation
import RxDataSources

struct HobbyItemViewModel: IdentifiableType, Equatable {
    var identity: String
    var cellTitle: String
    var status: HobbyCellStatus
}

struct SectionOfHobbyItemViewModel {
    var headerTitle: String
    var items: [HobbyItemViewModel]
}

extension SectionOfHobbyItemViewModel: AnimatableSectionModelType {
    var identity: String {
        return headerTitle
    }
    
    init(original: SectionOfHobbyItemViewModel, items: [HobbyItemViewModel]) {
        self = original
        self.items = items
    }
}
