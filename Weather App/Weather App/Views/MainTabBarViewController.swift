//
//  MainTabBarViewController.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit
import CoreLocation

class MainTabBarViewController: UITabBarController {
    let locationManager = LocationManager()
    var location: CLLocation?
    var isLocationEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func requestAuthorization() {
        isLocationEnabled = locationManager.isLocationEnabled
        if isLocationEnabled {
            locationManager.startUpdating()
        } else {
            locationManager.requestAuthorization()
        }
    }
}

extension MainTabBarViewController: LocationDelegate {
    func didChangeAuthorization(_ authorized: Bool) {
        if authorized && !isLocationEnabled{
            locationManager.startUpdating()
        }
        isLocationEnabled = authorized
    }
    
    func didUpdateLocations(_ location: CLLocation) {
        let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
        let locationDictionary = [LocationDictionaryKeys.latitude: location.coordinate.latitude,
                                  LocationDictionaryKeys.longitude: location.coordinate.longitude]
        NotificationCenter.default.post(name: notificationNameForLocationUpdate, object: locationDictionary, userInfo: nil)
    }
}
