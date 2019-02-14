//
//  WeatherDescriptionTests.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 14/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import XCTest
@testable import Weather_App

class WeatherDescriptionTests: XCTestCase {

    func testExample() {
        XCTAssertEqual(WeatherDescription.stringToIconName("01d"), "clear-sky-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("01n"), "clear-sky-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("02d"), "few-clouds-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("02n"), "few-clouds-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("03d"), "scattered-clouds-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("03n"), "scattered-clouds-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("04d"), "broken-clouds-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("04n"), "broken-clouds-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("09d"), "shower-rain-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("09n"), "shower-rain-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("10d"), "rain-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("10n"), "rain-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("11d"), "thunderstorm-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("11n"), "thunderstorm-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("13d"), "snow-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("13n"), "snow-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("50d"), "mist-day")
        XCTAssertEqual(WeatherDescription.stringToIconName("50n"), "mist-night")
        XCTAssertEqual(WeatherDescription.stringToIconName("60d"), General.none)
        XCTAssertEqual(WeatherDescription.stringToIconName("60n"), General.none)
    }

}
