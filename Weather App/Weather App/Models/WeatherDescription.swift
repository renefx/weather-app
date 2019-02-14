//
//  WeatherDescription.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct WeatherDescription: Codable {
    var id: Int
    var title: String
    var description: String
    var icon: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "main"
        case description = "description"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        
        let openWeatherIconName = try container.decode(String.self, forKey: .icon)
        self.icon = WeatherDescription.stringToIconName(openWeatherIconName)
    }
    
    static func stringToIconName (_ requestString: String) -> String {
        let iconName: String
        switch requestString {
        case "01d", "01n":
            iconName =   "clear-sky"
        case "02d", "02n":
            iconName =   "few-clouds"
        case "03d", "03n":
            iconName =   "scattered-clouds"
        case "04d", "04n":
            iconName =   "broken-clouds"
        case "09d", "09n":
            iconName =   "shower-rain"
        case "10d", "10n":
            iconName =   "rain"
        case "11d", "11n":
            iconName =   "thunderstorm"
        case "13d", "13n":
            iconName =   "snow"
        case "50d", "50n":
            iconName =   "mist"
        default:
            return General.none
        }
        return requestString.contains("d") ? "\(iconName)-day" : "\(iconName)-night"
    }
}
