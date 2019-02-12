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
    static let forecastTitle = "Forecast"
    static let today = "TODAY"
    static let noTime = "--:--"
    static let noWifiImage = "no-wifi"
    static let sadImage = "sad"
}

struct ErrorMessages {
    static let noInternet = "Check your Internet connection\nPull to refresh"
    static let unexpectedError = "No data available\nPull to refresh"
}

struct CellIdentifier {
    static let weatherInformationIdentifier = "weatherInformationIdentifier"
    static let loadingForecastIdentifier = "loadingForecastIdentifier"
    static let noDataAvailableIdentifier = "noDataAvailableIdentifier"
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
    static let cityName = "cityName"
}
