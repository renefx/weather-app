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
    func weatherUpdated(_ error: RequestErrors?)
    func temperatureScaleChanged()
}

class CurrentWeatherPresenter {
    weak var delegate: CurrentWeatherPresenterDelegate?
    var weather: WeatherResponse?
    var service = ServiceConnection()
    let jsonDecoder = JSONDecoder()
    
    // MARK: - Computed Properties For UI Elements
    var iconName: String {
        get {
            guard let weather = weather else {
                return Connectivity.isConnectedToInternet() ? General.reload : General.noWifiImage
            }
            return weather.iconName
        }
    }
    
    var cityFullName: String {
        get {
            guard let weather = weather else {
                return Connectivity.isConnectedToInternet() ? ErrorMessages.unexpectedErrorShort : ErrorMessages.noInternetShort
            }
            return weather.cityFullName
        }
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
    
    // MARK: - General Computed Properties
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
    
    private var userIsUsingGps: Bool {
        get {
            let isUsingGps = !UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotUsingGps)
            return isUsingGps
        }
    }
    
    // MARK: - Temperatura
    func setDefaultTemperatureScale() {
        let oldValue = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
        UserDefaults.standard.set(!oldValue, forKey: UserDefaultKeys.isFahrenheit)
        delegate?.temperatureScaleChanged()
    }
    
    // MARK: - Request
    func refreshCurrentWeather(_ userCoordinate: Coordinate? = nil) {
        guard Connectivity.isConnectedToInternet() else {
            self.weather = nil
            delegate?.weatherUpdated(.noInternet)
            return
        }
        
        var coordinate: Coordinate
        if let userCoordinate = userCoordinate {
            coordinate = userCoordinate
        } else {
            coordinate = Coordinate.getStoredLocation()
        }
        
        let url = ServiceConnection.urlForCurrentWeather(coordinate)
        service.makeHTTPGetRequest(url, WeatherResponse.self) { weather in
            self.weather = weather
            let response: RequestErrors? = weather != nil ? nil : .unexpectedError
            self.delegate?.weatherUpdated(response)
        }
    }
}
