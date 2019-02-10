//
//  CurrentWeatherController.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class CurrentWeatherController {
    
    open func updateWeatherInformation(_ latitude: Double,_ longitude: Double, handlerJsonResult: @escaping (Any?) -> ()) {
        guard Connectivity.isConnectedToInternet() else {
            return 
        }
        
        let url = OpenWeatherAPI.urlCurrentWeather +
            "lat=\(latitude)&lon=\(longitude)&appid=" +
            OpenWeatherAPI.apiKey
    }
}
