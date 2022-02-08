//
//  SectionOfHobbyCell.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/08.
//

import Foundation
import RxDataSources

struct HobbyCell: IdentifiableType, Equatable {
    var identity: String
    var cellTitle: String
}

struct SectionOfHobbyCell {
    var headerTitle: String
    var items: [HobbyCell]
}

extension SectionOfHobbyCell: AnimatableSectionModelType {
    var identity: String {
        return headerTitle
    }
    
    init(original: SectionOfHobbyCell, items: [HobbyCell]) {
        self = original
        self.items = items
    }
}
