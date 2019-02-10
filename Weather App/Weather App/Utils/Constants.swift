//
//  Constants.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct Titles {
    static let APP_NAME = "Weather App"
}

struct OpenWeatherAPI {
    static let url = "api.openweathermap.org/data/2.5/forecast?"
    static let apiKey = "b496cbb102e3b82b4e47438315bd449f"
}

struct NotificationNames {
    static let locationUpdated = "locationUpdated"
}

struct LocationDictionaryKeys {
    static let latitude = "latitude"
    static let longitude = "longitude"
}

