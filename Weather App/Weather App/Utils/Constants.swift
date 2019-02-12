//
//  Constants.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct General {
    static let none = ""
    static let dash = "-"
}

struct ErrorMessages {
    static let noInternet = "No Internet. The weather information is not up to date."
    static let unexpectedError = "Unexpected Error. The weather information is not up to date."
}

struct CellIdentifier {
    static let weatherInformationIdentifier = "weatherInformationIdentifier"
}

struct OpenWeatherAPI {
    static let urlCurrentWeather = "https://api.openweathermap.org/data/2.5/weather?"
    static let urlForecast = "https://api.openweathermap.org/data/2.5/forecast?"
    static let apiKey = "b496cbb102e3b82b4e47438315bd449f"
}

struct NotificationNames {
    static let locationUpdated = "locationUpdated"
}

struct UserDefaultKeys {
    static let isFahrenheit = "isFahrenheit"
    static let latitude = "latitude"
    static let longitude = "longitude"
}
