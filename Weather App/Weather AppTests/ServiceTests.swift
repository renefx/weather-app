//
//  ServiceTests.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 14/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import XCTest
import Fakery
@testable import Weather_App

class ServiceTests: XCTestCase {
    let faker = Faker()

    func testUrls() {
        let randomCoordinate = Coordinate(faker.number.randomDouble(),faker.number.randomDouble())
        let regexUrl = "https://.*lat=\(TestUtil.double)&lon=\(TestUtil.double)&units=metric&appid=.+"
        let checkRegexCurrentWeather = TestUtil.isRegexMatch(regex: regexUrl, in: ServiceConnection.urlForCurrentWeather(randomCoordinate))
        XCTAssertEqual(checkRegexCurrentWeather, true)
        
        let checkRegexForecast = TestUtil.isRegexMatch(regex: regexUrl, in: ServiceConnection.urlForForecast(randomCoordinate))
        XCTAssertEqual(checkRegexForecast, true)
    }

}
