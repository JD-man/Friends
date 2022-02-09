//
//  QueueBodyDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/09.
//

import Foundation

struct PostQueueBodyDTO {
    var type: Int = 2
    var region: Int
    var lat: Double
    var long: Double
    var hf: [String]
    
    init(model: PostQueueBodyModel) {
        self.type = model.type
        self.region = Int((model.lat + 90).setRegion + (model.long + 180).setRegion) ?? 0
        self.lat = model.lat
        self.long = model.long
        self.hf = model.hf
    }
}

extension PostQueueBodyDTO {
    func toParameters() -> Parameters {
        [
            "type": type,
            "region": region,
            "lat": lat,
            "long": long,
            "hf": hf
        ]
    }
}
