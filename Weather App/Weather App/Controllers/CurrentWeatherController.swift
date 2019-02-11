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
    
    open func updateWeatherInformation(_ latitude: Double,_ longitude: Double, handlerJsonResult: @escaping (Any?) -> ()) {
        guard Connectivity.isConnectedToInternet() else {
            handlerJsonResult(true)
            return
        }
        
        let url = OpenWeatherAPI.urlCurrentWeather +
            "lat=\(latitude)&lon=\(longitude)&appid=" +
            OpenWeatherAPI.apiKey
        
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)")
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
        print(url)
    }
}
