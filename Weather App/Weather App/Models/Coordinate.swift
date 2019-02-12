//
//  Coordinate.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    init(_ latitude: Double,_ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
