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
    var location: CLLocation?
    var isLocationEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LocationManager.shared.stopUpdatingLocation()
    }
    
    func requestAuthorization() {
        isLocationEnabled = LocationManager.shared.isLocationEnabled
        if isLocationEnabled {
            LocationManager.shared.startUpdating()
        } else {
            LocationManager.shared.requestAuthorization()
        }
    }
}

extension MainTabBarViewController: LocationDelegate {
    func didChangeAuthorization(_ authorized: Bool) {
        if authorized && !isLocationEnabled{
            LocationManager.shared.startUpdating()
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
