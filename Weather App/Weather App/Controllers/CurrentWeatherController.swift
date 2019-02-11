//
//  CurrentWeatherController.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class CurrentWeatherController {
    
    func updateWeatherInformation(_ latitude: Double,_ longitude: Double, handlerJsonResult: @escaping (Any?) -> ()) {
        guard Connectivity.isConnectedToInternet() else {
            handlerJsonResult(true)
            return
        }
        let latitude1 = 25.275581
        let longitude1 = 51.535682
        let url = OpenWeatherAPI.urlCurrentWeather +
            "lat=\(latitude1)&lon=\(longitude1)&units=metric&appid=" +
            OpenWeatherAPI.apiKey
        
        Alamofire.request(url).responseJSON { response in
            
            if let data = response.data {
                let jsonDecoder = JSONDecoder()
                do {
                    let weather = try jsonDecoder.decode(WeatherResponse.self, from: data)
                } catch let error {
                    handlerJsonResult(true)
                    return
                }
            }
        }
    }
}
