//
//  DayWeathers.swift
//  Weather App
//
//  Created by Renê Xavier on 12/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct DayWeathers: Codable {
    var weathers: [WeatherResponse]
    var dateForGroup: Date
    
    init(_ weathers: [WeatherResponse],_ dateForGroup: Date) {
        self.weathers = weathers
        self.dateForGroup = dateForGroup
    }
}
