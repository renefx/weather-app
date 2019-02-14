//
//  WeatherConditions.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct WeatherConditions: Codable {
    var temperature: Double
    var pressure: Double?
    var humidity: Double?
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    var temperatureCelsius: String {
        get { return "\(Int(temperature)) ºC" }
    }
    
    var temperatureCelsiusShort: String {
        get { return "\(Int(temperature))º" }
    }
    
    var temperatureFahrenheit: String {
        get {
            let fahrenheit = temperature * 9 / 5 + 32
            return "\(Int(fahrenheit)) F"
        }
    }
    
    var humidityPercentage: String {
        get { return "\(Int(humidity ?? 0))%" }
    }
    
    var pressureHpa: String {
        get { return "\(Int(pressure ?? 0)) hPa" }
    }
}
