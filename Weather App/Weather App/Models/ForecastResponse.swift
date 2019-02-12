//
//  ForecastResponse.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct ForecastResponse: Codable {
    let daysList: [DayWeathers]
    
    private enum CodingKeys: String, CodingKey {
        case daysList = "list"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let unsortedWeatherForecast = try container.decodeIfPresent([WeatherResponse].self, forKey: .daysList) {
            let sortedWeatherForecast = unsortedWeatherForecast.sorted {
                $0.date < $1.date
            }
            if let firstWeather = sortedWeatherForecast.first {
                var oldDate: Date = firstWeather.date
                var daysList: [DayWeathers] = []
                var weathersArray: [WeatherResponse] = []
                for weather in sortedWeatherForecast {
                    if Calendar.current.isDate(weather.date, inSameDayAs: oldDate) {
                        weathersArray.append(weather)
                    } else {
                        daysList.append(DayWeathers(weathersArray, oldDate))
                        weathersArray = [weather]
                        oldDate = weather.date
                    }
                }
                daysList.append(DayWeathers(weathersArray, oldDate))
                self.daysList = daysList
            } else {
                self.daysList = []
            }
        } else {
            self.daysList = []
        }
    }
}
