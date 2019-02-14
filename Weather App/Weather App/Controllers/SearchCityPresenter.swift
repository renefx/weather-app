//
//  SearchCityPresenter.swift
//  Weather App
//
//  Created by Renê Xavier on 12/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import CoreLocation

protocol SearchCityPresenterDelegate: AnyObject {
    func cityFound(_ feedback: String?)
    func didChangeCity()
}

class SearchCityPresenter {
    // MARK: - Variables
    weak var delegate: SearchCityPresenterDelegate?
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    
    private let notificationStopLocationUpdate = Notification.Name(NotificationNames.changeUpdate)
    private let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
    
    var userSwitchEnableGps: Bool {
        get {
            let isUsingGps = !UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotUsingGps)
            return isUsingGps
        }
    }
    
    func locationForName(_ city: String) {
        geocoder.geocodeAddressString(city) { placemarks, error in
            var feedback = ""
            guard let firstPlacemark = placemarks?.first else { return }
            self.placemark = firstPlacemark
            let country = firstPlacemark.country
            let region = firstPlacemark.administrativeArea
            let city = firstPlacemark.locality
            if let country = country, let region = region, let city = city {
                feedback = "\(city)\n\(region) - \(country)"
            } else if let country = country, let region = region {
                feedback = "\(region)\n\(country)"
            } else if let country = country {
                feedback = "\(country)"
            }
            self.delegate?.cityFound(feedback)
        }
    }
    
    func notifyCityChange(continueUsingGPS: Bool) {
        
        guard let placemark = self.placemark,
            let location = placemark.location else {
                NotificationCenter.default.post(name: notificationStopLocationUpdate, object: continueUsingGPS, userInfo: nil)
                delegate?.didChangeCity()
                return
        }
        
        NotificationCenter.default.post(name: notificationStopLocationUpdate, object: false, userInfo: nil)
        UserDefaults.standard.set(placemark.locality, forKey: UserDefaultKeys.cityName)
        let coordinate = Coordinate(location.coordinate.latitude, location.coordinate.longitude)
        UserDefaults.standard.set(coordinate.latitude, forKey: UserDefaultKeys.latitude)
        UserDefaults.standard.set(coordinate.longitude, forKey: UserDefaultKeys.longitude)
        delegate?.didChangeCity()
    }
}
