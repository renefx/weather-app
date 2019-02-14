//
//  WeatherConditionsTests.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 13/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import XCTest
import Fakery
@testable import Weather_App

class WeatherConditionsTests: XCTestCase {
    let faker = Faker()
    var randomTest,
        randomTest2,
        temperatureTest,
        temperatureTest2,
        humidityTest,
        humidityConversionTest,
        pressureTest: WeatherConditions?

    override func setUp() {
        randomTest = WeatherConditions(temperature: faker.number.randomDouble(), pressure: faker.number.randomDouble(), humidity: faker.number.randomDouble())
        randomTest2 = WeatherConditions(temperature: faker.number.randomDouble(), pressure: faker.number.randomDouble(), humidity: faker.number.randomDouble())
        temperatureTest = WeatherConditions(temperature: 0, pressure: 0, humidity: 0)
        temperatureTest2 = WeatherConditions(temperature: 32, pressure: 0, humidity: 0)
        humidityConversionTest = WeatherConditions(temperature: 0, pressure: 0, humidity: 10)
        pressureTest = WeatherConditions(temperature: 0, pressure: 10, humidity: 0)
    }
    
    func testRandom() {
        let regexCelsius = "[0-9]* ºC"
        let regexFahrenheit = "[0-9]* F"
        let checkRegexCelsius = TestUtil.isRegexMatch(regex: regexCelsius, in: randomTest?.temperatureCelsius)
        let checkRegexFahrenheit = TestUtil.isRegexMatch(regex: regexFahrenheit, in: randomTest?.temperatureFahrenheit)
        XCTAssertEqual(checkRegexCelsius, true)
        XCTAssertEqual(checkRegexFahrenheit, true)
        
        
        let checkRegexCelsius2 = TestUtil.isRegexMatch(regex: regexCelsius, in: randomTest2?.temperatureCelsius)
        XCTAssertEqual(checkRegexCelsius2, true)
        let checkRegexFahrenheit2 = TestUtil.isRegexMatch(regex: regexFahrenheit, in: randomTest2?.temperatureFahrenheit)
        XCTAssertEqual(checkRegexFahrenheit2, true)
    }
    
    func testTemperature() {
        XCTAssertEqual(temperatureTest?.temperature, 0)
        XCTAssertEqual(temperatureTest?.temperatureCelsius, "0 ºC")
        XCTAssertEqual(temperatureTest?.temperatureFahrenheit, "32 F")
        XCTAssertNotNil(temperatureTest?.temperature)
        
        
        XCTAssertEqual(temperatureTest2?.temperature, 32)
        XCTAssertEqual(temperatureTest2?.temperatureCelsius, "32 ºC")
        XCTAssertEqual(temperatureTest2?.temperatureFahrenheit, "89 F")
        XCTAssertNotEqual(temperatureTest2?.temperatureFahrenheit, "89.6 F")
        XCTAssertNotNil(temperatureTest?.temperature)
        
        
    }
    
    func testHumidityPercentage() {
        let humidityTest = WeatherConditions(temperature: 0, pressure: 0, humidity: 0)
        
        XCTAssertEqual(humidityTest.humidity, 0)
        XCTAssertEqual(humidityTest.humidityPercentage, "0%")
        XCTAssertNotNil(humidityTest.humidity)
    }
    
    func testHumidityConversionWrong() {
        
        XCTAssertNotEqual(humidityConversionTest?.humidity, 0)
        XCTAssertNotEqual(humidityConversionTest?.humidityPercentage, "0%")
        XCTAssertNotEqual(humidityConversionTest?.humidityPercentage, "10 %")
        XCTAssertNotNil(humidityConversionTest?.humidity)
    }
    
    func testPressure() {
        XCTAssertEqual(pressureTest?.pressure, 10)
        XCTAssertNotEqual(pressureTest?.pressure, 0)
        XCTAssertNotNil(pressureTest?.pressure)
    }
}
