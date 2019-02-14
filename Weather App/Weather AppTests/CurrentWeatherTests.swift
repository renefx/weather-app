//
//  CurrentWeatherTests.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 14/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import XCTest
import Fakery
@testable import Weather_App

class CurrentWeatherTests: XCTestCase {
    let faker = Faker()
    let presenter = CurrentWeatherPresenter()
    let domain = Bundle.main.bundleIdentifier
    var weatherUpdatedError: RequestErrors?
    
    let weatherUpdatedExpectation = XCTestExpectation(description: "waits for a request from server")
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

    func testCurrentWeatherRequest() {
        let latitude = faker.number.randomDouble()
        let longitude = faker.number.randomDouble()
        let coordinate = Coordinate(latitude, longitude)
        presenter.refreshCurrentWeather(coordinate)
        wait(for: [weatherUpdatedExpectation], timeout: 15)
        if (weatherUpdatedError == nil) {
            if let requestWeather = presenter.weather {
                let requestCoordinate = requestWeather.coordinate
                XCTAssertEqual(requestCoordinate?.latitude, coordinate.latitude)
                XCTAssertEqual(requestCoordinate?.longitude, coordinate.longitude)
            } else {
                XCTFail()
            }
        }
    }
    
    func testForecastRequestWithLocalData() {
        let latitude = faker.number.randomDouble()
        let longitude = faker.number.randomDouble()
        Coordinate(latitude, longitude).saveCoordinate()
        
        presenter.refreshCurrentWeather()
        wait(for: [weatherUpdatedExpectation], timeout: 15)
        if (weatherUpdatedError == nil) {
            if let requestWeather = presenter.weather {
                if let firstRequestCoordinate = requestWeather.coordinate {
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

extension CurrentWeatherTests: CurrentWeatherPresenterDelegate {
    func weatherUpdated(_ error: RequestErrors?) {
        weatherUpdatedError = error
        weatherUpdatedExpectation.fulfill()
    }
    
    func temperatureScaleChanged() {
        temperatureScaleChangedExpectation.fulfill()
    }
}
