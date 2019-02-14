//
//  ServiceConnection.swift
//  Weather App
//
//  Created by Renê Xavier on 13/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import Alamofire

class ServiceConnection {
    let jsonDecoder = JSONDecoder()
    
    // MARK: - URL with parameters
    static func urlForCurrentWeather(_ coordinate: Coordinate) -> String {
        let url = OpenWeatherAPI.urlCurrentWeather +
            "lat=\(coordinate.latitude)" +
            "&lon=\(coordinate.longitude)" +
            "&units=metric" +
            "&appid=" + OpenWeatherAPI.apiKey
        return url
    }
    
    static func urlForForecast(_ coordinate: Coordinate) -> String {
        let url = OpenWeatherAPI.urlForecast +
            "lat=\(coordinate.latitude)" +
            "&lon=\(coordinate.longitude)" +
            "&units=metric" +
            "&appid=" + OpenWeatherAPI.apiKey
        return url
    }
    
    // MARK: - Custom Requests (Get - Post - Authentication)
    func makeHTTPGetRequest<T:Codable>(_ url: String,_ type: T.Type, onCompletion: @escaping (T?) -> Void) {
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                do {
                    let object = try self.jsonDecoder.decode(type, from: data)
                    onCompletion(object)
                    return
                } catch {
                    onCompletion(nil)
                }
            }
        }
    }
}
