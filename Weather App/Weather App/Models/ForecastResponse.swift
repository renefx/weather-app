//
//  ForecastResponse.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [WeatherResponse]
}
