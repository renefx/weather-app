//
//  WindTest.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 14/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import XCTest
import Fakery
@testable import Weather_App

class WindTest: XCTestCase {
    let faker = Faker()

    func testExample() {
        XCTAssertEqual(Wind.degreeToDirection(nil), General.dash)
        XCTAssertEqual(Wind.degreeToDirection(-1), General.dash)
        let randomNumber = -faker.number.randomDouble()
        XCTAssertEqual(Wind.degreeToDirection(randomNumber), General.dash)
        XCTAssertEqual(Wind.degreeToDirection(0), "N")
        XCTAssertEqual(Wind.degreeToDirection(44.9), "N")
        XCTAssertEqual(Wind.degreeToDirection(45), "NE")
        XCTAssertEqual(Wind.degreeToDirection(89.9), "NE")
        XCTAssertEqual(Wind.degreeToDirection(90), "E")
        XCTAssertEqual(Wind.degreeToDirection(134.9), "E")
        XCTAssertEqual(Wind.degreeToDirection(135), "SE")
        XCTAssertEqual(Wind.degreeToDirection(179.9), "SE")
        XCTAssertEqual(Wind.degreeToDirection(180), "S")
        XCTAssertEqual(Wind.degreeToDirection(224.9), "S")
        XCTAssertEqual(Wind.degreeToDirection(225), "SW")
        XCTAssertEqual(Wind.degreeToDirection(269.9), "SW")
        XCTAssertEqual(Wind.degreeToDirection(270), "W")
        XCTAssertEqual(Wind.degreeToDirection(314.9), "W")
        XCTAssertEqual(Wind.degreeToDirection(315), "NW")
        XCTAssertEqual(Wind.degreeToDirection(359.9), "NW")
        XCTAssertEqual(Wind.degreeToDirection(360), "N")
    }

}
