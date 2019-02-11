//
//  Wind.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct Wind: Codable {
    let speed: Double?
    let direction: String
    
    var speedKmh: String {
        get { return "\(speed ?? 0) km/h" }
    }
    
    private enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case direction = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decodeIfPresent(Double.self, forKey: .speed)
        if let degree = try container.decodeIfPresent(Double.self, forKey: .direction), degree > 0 {
            print(degree)
            let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
            let index = Int((degree + 22.5) / 45.0) & 7
            self.direction = directions[index]
        } else {
            self.direction = ""
        }
    }
}
