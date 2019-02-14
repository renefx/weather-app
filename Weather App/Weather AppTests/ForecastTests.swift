//
//  ForecastTests.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 14/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import XCTest
import Fakery
@testable import Weather_App

class ForecastTests: XCTestCase {
    let faker = Faker()
    let presenter = ForecastPresenter()
    let domain = Bundle.main.bundleIdentifier
    var forecastUpdatedError: RequestErrors?
    
    let forecastUpdatedExpectation = XCTestExpectation(description: "waits for a request from server")
    let temperatureScaleChangedExpectation = XCTestExpectation(description: "waits for the change of scela in user defaults")
    
    override func setUp() {
        presenter.delegate = self
        if let domain = domain {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
    }
    
    override func tearDown() {
        if let domain = domain {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
    }
    
    func testForecastRequest() {
        let latitude = faker.number.randomDouble()
        let longitude = faker.number.randomDouble()
        let coordinate = Coordinate(latitude, longitude)
        presenter.refreshForecastWeather(coordinate)
        wait(for: [forecastUpdatedExpectation], timeout: 15)
        if (forecastUpdatedError == nil) {
            if let forecast = presenter.forecast {
                if let firstRequestCoordinate = forecast.daysList.first?.weathers.first?.coordinate {
                    XCTAssertEqual(firstRequestCoordinate.latitude, latitude)
                    XCTAssertEqual(firstRequestCoordinate.longitude, longitude)
                }
            } else {
                XCTFail()
            }
        }
    }
    
    func testForecastRequestWithLocalData() {
        let latitude = faker.number.randomDouble()
        let longitude = faker.number.randomDouble()
        Coordinate(latitude, longitude).saveCoordinate()
        
        presenter.refreshForecastWeather()
        wait(for: [forecastUpdatedExpectation], timeout: 15)
        if (forecastUpdatedError == nil) {
            if let forecast = presenter.forecast {
                if let firstRequestCoordinate = forecast.daysList.first?.weathers.first?.coordinate {
                    XCTAssertEqual(firstRequestCoordinate.latitude, latitude)
                    XCTAssertEqual(firstRequestCoordinate.longitude, longitude)
                }
            } else {
                XCTFail()
            }
        }
    }
    
    func testDefaultTemperatureScale() {
        let isFahrenheitRandom = faker.number.randomBool()
        UserDefaults.standard.set(isFahrenheitRandom, forKey: UserDefaultKeys.isFahrenheit)
        presenter.setDefaultTemperatureScale()
        let boolSaved = UserDefaults.standard.bool(forKey: UserDefaultKeys.isFahrenheit)
        wait(for: [temperatureScaleChangedExpectation], timeout: 1)
        XCTAssertEqual(boolSaved, !isFahrenheitRandom)
    }
    
}

extension ForecastTests: ForecastPresenterDelegate {
    func forecastUpdated(_ error: RequestErrors?) {
        forecastUpdatedError = error
        forecastUpdatedExpectation.fulfill()
    }
    
    func temperatureScaleChanged() {
        temperatureScaleChangedExpectation.fulfill()
    }
}
