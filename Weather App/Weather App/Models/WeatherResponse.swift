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
    let country: String
    let city: String
    
    var iconName: String {
        get { return description.count > 0 ? description[0].icon : "" }
    }
    
    var cityFullName: String {
        get { return "\(city), \(country)" }
    }
    
    var weatherTitle: String {
        get { return description.count > 0 ? description[0].title : "" }
    }
    
    var precipitation: String {
        get {
            guard let rain = rain else {
                return "- mm"
            }
            if let lastHour = rain.lastHour {
                return "\(lastHour) mm"
            } else if let lastThreeHours = rain.lastThreeHours {
                return "\(lastThreeHours) mm"
            }
            return "0 mm"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case description = "weather"
        case weatherConditions = "main"
        case wind = "wind"
        case rain = "rain"
        case date = "dt"
        case country = "sys"
        case city = "name"
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
        self.country = Locale.current.localizedString(forRegionCode: countryName.countryCode) ?? ""
        self.city = try container.decode(String.self, forKey: .city)
    }
}
