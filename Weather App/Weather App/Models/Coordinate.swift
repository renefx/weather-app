//
//  Coordinate.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    init(_ latitude: Double,_ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func getStoredLocation() -> Coordinate {
        let latitude = UserDefaults.standard.double(forKey: UserDefaultKeys.latitude)
        let longitude = UserDefaults.standard.double(forKey: UserDefaultKeys.longitude)
        return Coordinate(latitude, longitude)
    }
    
    func saveCoordinate() {
        UserDefaults.standard.set(self.latitude, forKey: UserDefaultKeys.latitude)
        UserDefaults.standard.set(self.longitude, forKey: UserDefaultKeys.longitude)
    }
}
