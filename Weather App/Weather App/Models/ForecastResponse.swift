//
//  ForecastResponse.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct ForecastResponse: Codable {
    let forecast: [[WeatherResponse]]
    
    private enum CodingKeys: String, CodingKey {
        case forecast = "list"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let weatherForecast = try container.decodeIfPresent([WeatherResponse].self, forKey: .forecast) {
            let x: [[WeatherResponse]] = [weatherForecast]
            self.forecast = x
        } else {
            self.forecast = []
        }
    }
}
