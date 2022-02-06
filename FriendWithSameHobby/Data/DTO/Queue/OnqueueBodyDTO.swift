//
//  OnqueueDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/06.
//

import Foundation

struct OnqueueBodyDTO: Codable {
    var region: Int
    var lat: Double
    var long: Double
    
    init(model: OnqueueBodyModel) {
        self.region = Int((model.lat + 90).setRegion + (model.long + 180).setRegion) ?? 0
        self.lat = model.lat
        self.long = model.long
    }
}

extension OnqueueBodyDTO {
    func toParamteres() -> Parameters {
        [
            "region": region,
            "lat": lat,
            "long": long
        ]
    }
}
