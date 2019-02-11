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

enum TemperatureScale {
    case Celsius
    case Fahrenheit
}

class CurrentWeatherPresenter {
    weak var delegate: CurrentWeatherPresenterDelegate?
    var weather: WeatherResponse?
    var iconName: String {
        get { return weather?.iconName ?? "" }
    }
    
    var cityFullName: String {
        get { return weather?.cityFullName ?? "" }
    }
    
    var temperature: String {
        get {
            let isFahrenheit = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
            let temperature = isFahrenheit ? weather?.weatherConditions.temperatureFahrenheit : weather?.weatherConditions.temperatureCelsius
            return temperature ?? "-"
        }
    }
    
    var weatherTitle: String {
        get { return weather?.weatherTitle ?? "" }
    }
    
    var humidity: String {
        get { return weather?.weatherConditions.humidityPercentage ?? "" }
    }
    
    var precipitation: String {
        get { return weather?.precipitation ?? "" }
    }
    
    var pressure: String {
        get { return weather?.weatherConditions.pressureHpa ?? "" }
    }
    
    var windSpeed: String {
        get { return weather?.wind.speedKmh ?? "" }
    }
    
    var windDirection: String {
        get { return weather?.wind.direction ?? "" }
    }
    
    func setDefaultTemperatureScale() {
        let oldValue = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
        UserDefaults.standard.set(!oldValue, forKey: UserDefaultKeys.isFahrenheit)
        delegate?.temperatureScaleChanged()
    }
    
    func updateWeatherInformation(_ latitude: Double,_ longitude: Double) {
        guard Connectivity.isConnectedToInternet() else {
            delegate?.weatherUpdated(ErrorMessages.noInternet)
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
