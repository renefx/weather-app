//
//  ForecastController.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import Alamofire

protocol ForecastPresenterDelegate: AnyObject {
    func forecastUpdated(_ error: String?)
}

class ForecastPresenter {
    weak var delegate: ForecastPresenterDelegate?
    var forecast: ForecastResponse?
    
    var isDay: Bool {
        get {
            if let currentWeather = forecast?.daysList.first?.weathers.first {
                return currentWeather.iconName.contains("day")
            }
            return true
        }
    }
    
    var navigationBarTitle: String {
        get {
            if let cityName = UserDefaults.standard.string(forKey: UserDefaultKeys.cityName) {
                return cityName
            }
            return General.forecastTitle
        }
    }
    
    func userRefreshWeatherInformation() {
        let latitude = UserDefaults.standard.double(forKey: UserDefaultKeys.latitude)
        let longitude = UserDefaults.standard.double(forKey: UserDefaultKeys.longitude)
        updateWeatherInformation(latitude, longitude)
    }
    
    func updateWeatherInformation(_ latitude: Double,_ longitude: Double) {
        guard Connectivity.isConnectedToInternet() else {
            delegate?.forecastUpdated(ErrorMessages.noInternet)
            return
        }
        
        let url = OpenWeatherAPI.urlForecast +
            "lat=\(latitude)&lon=\(longitude)&units=metric&appid=" +
            OpenWeatherAPI.apiKey
        
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let jsonDecoder = JSONDecoder()
                do {
                    self.forecast = try jsonDecoder.decode(ForecastResponse.self, from: data)
                    self.delegate?.forecastUpdated(nil)
                } catch {
                    self.delegate?.forecastUpdated(ErrorMessages.unexpectedError)
                    return
                }
            }
        }
    }
}
