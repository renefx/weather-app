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
    func temperatureScaleChanged()
}

class ForecastPresenter {
    // MARK: - Variables
    weak var delegate: ForecastPresenterDelegate?
    private var forecast: ForecastResponse?
    
    // MARK: - Computated Variables
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
    
    var numberOfSections: Int {
        get {
            return forecast?.daysList.count ?? 1
        }
    }
    
    var existForecast: Bool {
        get {
            if let forecast = forecast, forecast.daysList.count > 0 {
                return true
            }
            return false
        }
    }
    
    var isConnected: Bool {
        get { return Connectivity.isConnectedToInternet() }
    }
    
    var userIsUsingGps: Bool {
        get {
            let isUsingGps = !UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotUsingGps)
            return isUsingGps
        }
    }
    
    // MARK: - Section treatment
    func rowsForSection(_ section: Int) -> Int {
        guard let forecast = forecast, section < forecast.daysList.count else {
            return 1
        }
        return forecast.daysList[section].weathers.count
    }
    
    func titleForSection(_ section: Int) -> String {
        guard let forecast = forecast, section < forecast.daysList.count else {
            return General.none
        }
        let dateForSection = forecast.daysList[section].dateForGroup
        return dateForSection.dayOfWeekToday ?? General.none
    }
    
    // MARK: - Cell treatment
    func getWeather(atIndexPath indexPath: IndexPath) -> WeatherResponse? {
        let section = indexPath.section
        let row = indexPath.row
        guard let forecast = forecast, section < forecast.daysList.count, row < forecast.daysList[section].weathers.count else {
            return nil
        }
        return forecast.daysList[section].weathers[row]
    }
    
    func iconNameForCell(atIndexPath indexPath: IndexPath) -> String {
        if let weather = getWeather(atIndexPath: indexPath) {
            return weather.iconName
        }
        return General.none
    }
    
    func timeForCell(atIndexPath indexPath: IndexPath) -> String {
        if let weather = getWeather(atIndexPath: indexPath) {
            return weather.date.hourMinutes
        }
        return General.noTime
    }
    
    func weatherTitleForCell(atIndexPath indexPath: IndexPath) -> String {
        if let weather = getWeather(atIndexPath: indexPath), let title = weather.description.first?.description {
            return title.capitalized
        }
        return General.none
    }
    
    func temperatureForCell(atIndexPath indexPath: IndexPath) -> String {
        if let weather = getWeather(atIndexPath: indexPath) {
            let isFahrenheit = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
            return isFahrenheit ? weather.weatherConditions.temperatureFahrenheit : weather.weatherConditions.temperatureCelsius
        }
        return General.none
    }
    
    func setDefaultTemperatureScale() {
        let oldValue = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
        UserDefaults.standard.set(!oldValue, forKey: UserDefaultKeys.isFahrenheit)
        delegate?.temperatureScaleChanged()
    }
    
    // MARK: - API Connection
    func userRefreshForecastData() {
        let latitude = UserDefaults.standard.double(forKey: UserDefaultKeys.latitude)
        let longitude = UserDefaults.standard.double(forKey: UserDefaultKeys.longitude)
        updateForecast(latitude, longitude)
    }
    
    func updateForecast(_ latitude: Double,_ longitude: Double) {
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
