//
//  Wind.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct Wind: Codable {
    var speed: Double?
    var direction: String
    
    var speedKmh: String {
        get { return "\(Int(speed ?? 0)) km/h" }
    }
    
    private enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case direction = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decodeIfPresent(Double.self, forKey: .speed)
        let degree = try container.decodeIfPresent(Double.self, forKey: .direction)
        self.direction = Wind.degreeToDirection(degree)
    }
    
    static func degreeToDirection(_ degreeReveived: Double?) -> String {
        guard let degreeReveived = degreeReveived, degreeReveived >= 0 else { return General.dash }
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        
        let degree = Int(degreeReveived) % 360
        var index = 0
        if degree < 45 {
            index = 0
        } else if degree < 90 {
            index = 1
        } else if degree < 135 {
            index = 2
        } else if degree < 180 {
            index = 3
        } else if degree < 225 {
            index = 4
        } else if degree < 270 {
            index = 5
        } else if degree < 315 {
            index = 6
        } else if degree < 360 {
            index = 7
        }
        return directions[index]
    }
}
