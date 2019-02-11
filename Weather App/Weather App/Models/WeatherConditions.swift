//
//  WeatherConditions.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct WeatherConditions: Codable {
    let temperature: Double
    let pressure: Double?
    let humidity: Double?
    var temperatureCelsius: String {
        get { return "\(temperature) ºC" }
    }
    
    var temperatureFahrenheit: String {
        get { return "\(temperature * 9 / 5 + 32) ºF" }
    }
    
    var humidityPercentage: String {
        get { return "\(humidity ?? 0)%" }
    }
    
    var pressureHpa: String {
        get { return "\(pressure ?? 0) hPa" }
    }
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}
