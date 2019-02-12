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
    
    let locationManager = CLLocationManager()
    var authorizationType = CLAuthorizationStatus.authorizedWhenInUse
    var currentLocation = CLLocation()
    
    override init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
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