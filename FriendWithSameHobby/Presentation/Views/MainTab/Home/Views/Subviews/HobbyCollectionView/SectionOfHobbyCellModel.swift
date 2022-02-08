//
//  SectionOfHobbyCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/08.
//

import Foundation
import RxDataSources

struct HobbyCellModel: IdentifiableType, Equatable {
    var identity: String
    var cellTitle: String
    var status: HobbyCellStatus
}

struct SectionOfHobbyCellModel {
    var headerTitle: String
    var items: [HobbyCellModel]
}

extension SectionOfHobbyCellModel: AnimatableSectionModelType {
    var identity: String {
        return headerTitle
    }
    
    init(original: SectionOfHobbyCellModel, items: [HobbyCellModel]) {
        self = original
        self.items = items
    }
}
