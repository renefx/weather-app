//
//  LocationManager.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationDelegate: AnyObject {
    func didChangeAuthorization(_ authorized: Bool)
    func didUpdateLocations(_ location: CLLocation)
}

class LocationManager: NSObject {
    weak var delegate : LocationDelegate?
    
    private let locationManager = CLLocationManager()
    private var authorizationType = CLAuthorizationStatus.authorizedWhenInUse
    private var currentLocation = CLLocation()
    private let notificationCheckChangeUpdate = Notification.Name(NotificationNames.changeUpdate)
    
    static var userSwitchEnableGps: Bool {
        get {
            let isUsingGps = !UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotUsingGps)
            return isUsingGps
        }
    }
    
    override init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkChangeUpdate(notification:)), name: notificationCheckChangeUpdate, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: notificationCheckChangeUpdate, object: nil)
    }
    
    @objc func checkChangeUpdate(notification: Notification) {
        guard let userSwitchEnableGps = notification.object as? Bool else {
            return
        }
        
        UserDefaults.standard.set(!userSwitchEnableGps, forKey: UserDefaultKeys.isNotUsingGps)
        
        if userSwitchEnableGps {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    var isLocationEnabled: Bool {
        get {
            
            return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == authorizationType
        }
    }
    
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating(distanceFilter: Double = 5000) {
        if (isLocationEnabled) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = distanceFilter
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        delegate?.didUpdateLocations(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status == authorizationType)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
}
