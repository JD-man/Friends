//
//  ReportBodyDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/18.
//

import Foundation

struct ReportUserDTO {
    let otheruid: String
    let reportedReputation: [Int]
    let comment: String
    
    init(model: ReportUserModel) {
        self.otheruid = model.otheruid
        self.reportedReputation = model.reportedReputation.map { $0 == .fill ? 1 : 0 } + [0, 0]
        self.comment = model.comment
    }
}

extension ReportUserDTO {
    func toParameters() -> Parameters {
        return [
            "otheruid": otheruid,
            "reportedReputation": reportedReputation,
            "comment": comment
        ]
    }
}
