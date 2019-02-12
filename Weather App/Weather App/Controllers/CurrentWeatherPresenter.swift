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

protocol CurrentWeatherPresenterDelegate: AnyObject {
    func weatherUpdated(_ error: String?)
    func temperatureScaleChanged()
}

class CurrentWeatherPresenter {
    weak var delegate: CurrentWeatherPresenterDelegate?
    var weather: WeatherResponse?
    var iconName: String {
        get { return weather?.iconName ?? General.none }
    }
    
    var cityFullName: String {
        get { return weather?.cityFullName ?? General.dash }
    }
    
    var temperature: String {
        get {
            let isFahrenheit = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
            let temperature = isFahrenheit ? weather?.weatherConditions.temperatureFahrenheit : weather?.weatherConditions.temperatureCelsius
            return temperature ?? General.dash
        }
    }
    
    var weatherTitle: String {
        get { return weather?.weatherTitle ?? General.dash }
    }
    
    var humidity: String {
        get { return weather?.weatherConditions.humidityPercentage ?? General.dash }
    }
    
    var precipitation: String {
        get { return weather?.precipitation ?? General.dash }
    }
    
    var pressure: String {
        get { return weather?.weatherConditions.pressureHpa ?? General.dash }
    }
    
    var windSpeed: String {
        get { return weather?.wind.speedKmh ?? General.dash }
    }
    
    var windDirection: String {
        get { return weather?.wind.direction ?? General.dash }
    }
    
    var shareMessage: String {
        get {
            return "Hey! It's \(temperature) right now in \(cityFullName)! Check it out!"
        }
    }
    
    private var cityId: String {
        get { return weather?.cityId ?? General.none }
    }
    
    var shareLink: URL? {
        get {
            if let url = URL(string: "https://openweathermap.org/city/\(cityId)") {
                return url
            }
            return nil
        }
    }
    
    var isDay: Bool {
        get { return iconName.contains("day") }
    }
    
    var userIsUsingGps: Bool {
        get {
            let isUsingGps = !UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotUsingGps)
            return isUsingGps
        }
    }
    
    func setDefaultTemperatureScale() {
        let oldValue = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
        UserDefaults.standard.set(!oldValue, forKey: UserDefaultKeys.isFahrenheit)
        delegate?.temperatureScaleChanged()
    }
    
    func userRefreshWeatherInformation() {
        let latitude = UserDefaults.standard.double(forKey: UserDefaultKeys.latitude)
        let longitude = UserDefaults.standard.double(forKey: UserDefaultKeys.longitude)
        updateWeatherInformation(latitude, longitude)
    }
    
    func updateWeatherInformation(_ latitude: Double,_ longitude: Double) {
        guard Connectivity.isConnectedToInternet() else {
            delegate?.weatherUpdated(ErrorMessages.noInternet)
            return
        }
        
        let url = OpenWeatherAPI.urlCurrentWeather +
            "lat=\(latitude)&lon=\(longitude)&units=metric&appid=" +
            OpenWeatherAPI.apiKey
        
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let jsonDecoder = JSONDecoder()
                do {
                    self.weather = try jsonDecoder.decode(WeatherResponse.self, from: data)
                    self.delegate?.weatherUpdated(nil)
                } catch {
                    self.delegate?.weatherUpdated(ErrorMessages.unexpectedError)
                    return
                }
            }
        }
    }
}
