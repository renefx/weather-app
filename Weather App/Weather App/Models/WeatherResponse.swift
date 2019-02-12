//
//  WeatherResponse.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    let coordinate: Coordinate?
    let description: [WeatherDescription]
    let weatherConditions: WeatherConditions
    let wind: Wind
    let rain: Rain?
    let date: Date
    let country: String?
    let city: String?
    let cityId: String
    
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case description = "weather"
        case weatherConditions = "main"
        case wind = "wind"
        case rain = "rain"
        case date = "dt"
        case country = "sys"
        case city = "name"
        case cityId = "id"
    }
    
    var iconName: String {
        get { return description.count > 0 ? description[0].icon : General.none }
    }
    
    var cityFullName: String {
        get {
            if let country = country, let city = city {
                return "\(city), \(country)"
            } else if let city = city {
                return "\(city)"
            } else if let country = country {
                return "\(country)"
            }
            return General.none
        }
    }
    
    var weatherTitle: String {
        get { return description.count > 0 ? description[0].title : General.none }
    }
    
    var precipitation: String {
        get {
            guard let rain = rain else {
                return General.dash
            }
            if let lastHour = rain.lastHour {
                return "\(lastHour.toStringWithOneDecimal) mm"
            } else if let lastThreeHours = rain.lastThreeHours {
                return "\(lastThreeHours.toStringWithOneDecimal) mm"
            }
            return "0 mm"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coordinate = try container.decodeIfPresent(Coordinate.self, forKey: .coordinate)
        self.description = try container.decode([WeatherDescription].self, forKey: .description)
        self.weatherConditions = try container.decode(WeatherConditions.self, forKey: .weatherConditions)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        let timeInterval: TimeInterval = try container.decode(TimeInterval.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: timeInterval)
        let countryName = try container.decode(Country.self, forKey: .country)
        if let countryCode = countryName.countryCode {
            self.country = Locale.current.localizedString(forRegionCode: countryCode)
        } else {
            self.country = nil
        }
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        if let cityId = try container.decodeIfPresent(Int.self, forKey: .cityId) {
            self.cityId = "\(cityId)"
        } else {
            self.cityId = General.none
        }
    }
}
