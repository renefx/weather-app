//
//  ForecastController.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

class ForecastController {
    var navigationBarTitle: String {
        get {
            if let cityName = UserDefaults.standard.string(forKey: UserDefaultKeys.cityName) {
                return cityName
            }
            return General.forecastTitle
        }
    }
}
