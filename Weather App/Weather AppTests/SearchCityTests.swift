//
//  SearchCityTests.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 09/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import XCTest
import Fakery
@testable import Weather_App

class SearchCityTests: XCTestCase, SearchCityPresenterDelegate {
    let faker = Faker()
    var cityString: String?
    var continueUsingGPS = false
    let presenter = SearchCityPresenter()
    let domain = Bundle.main.bundleIdentifier
    
    let cityChangedExpectation = XCTestExpectation(description: "waits for city to change and data to be stored")
    let cityFoundExpectation = XCTestExpectation(description: "waits until a city is found for a given location")
    let stopUpdatingLocationExpectation = XCTestExpectation(description: "waits for a notification to stop updating location")
    
    let notificationStopLocationUpdate = Notification.Name(NotificationNames.changeUpdate)

    override func setUp() {
        presenter.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(checkChangeUpdate(notification:)), name: notificationStopLocationUpdate, object: nil)
        if let domain = domain {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
    }
    
    override func tearDown() {
        if let domain = domain {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
    }

    func testLocationForName() {
        let fakeCity = faker.address.country() // Portugal
        presenter.locationForName(fakeCity)
        wait(for: [cityFoundExpectation], timeout: 1)
        
        let regexCityName = "[\(TestUtil.stringRegex)]?" + "[\n\(TestUtil.stringRegex)]?" + "[ - \(TestUtil.stringRegex)]?"
        let checkRegexCity = TestUtil.isRegexMatch(regex: regexCityName, in: self.cityString)
        XCTAssertEqual(checkRegexCity, true)
        
        let placemark = presenter.placemark
        let continueUsingGPS = faker.number.randomBool() // true
        presenter.notifyCityChange(continueUsingGPS: continueUsingGPS)
        
        wait(for: [stopUpdatingLocationExpectation], timeout: 1)
        
        wait(for: [cityChangedExpectation], timeout: 1)
        
        let storedCoordinate = Coordinate.getStoredLocation()
        let storedCityName = UserDefaults.standard.string(forKey: UserDefaultKeys.cityName)
        XCTAssertEqual(storedCoordinate.latitude, placemark?.location?.coordinate.latitude)
        XCTAssertEqual(storedCoordinate.longitude, placemark?.location?.coordinate.longitude)
        XCTAssertEqual(storedCityName, placemark?.locality)
        
    }
    
    func cityFound(_ feedback: String?) {
        self.cityString = feedback
        cityFoundExpectation.fulfill()
    }
    
    func didChangeCity() {
        cityChangedExpectation.fulfill()
    }
    
    @objc func checkChangeUpdate(notification: Notification) {
        guard let userSwitchEnableGps = notification.object as? Bool else {
            XCTFail()
            return
        }
        self.continueUsingGPS = userSwitchEnableGps
        stopUpdatingLocationExpectation.fulfill()
    }
}
