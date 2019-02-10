//
//  CurrentWeatherController.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import CoreLocation

protocol CurrentWeatherControllerDelegate: AnyObject {
    func locationGathered()
}

class CurrentWeatherController {
    weak var delegate : CurrentWeatherControllerDelegate?
    var location: CLLocation?
    var isLocationEnabled = false
    
    init() {
        LocationManager.shared.delegate = self
    }
    
    func requestAuthorization() {
        isLocationEnabled = LocationManager.shared.isLocationEnabled
        if !isLocationEnabled {
            LocationManager.shared.requestAuthorization()
        }
    }
    
    func gatherLocation() {
        LocationManager.shared.startUpdating()
    }
}

extension CurrentWeatherController: LocationDelegate {
    func didChangeAuthorization(_ authorized: Bool) {
        if authorized && !isLocationEnabled{
            LocationManager.shared.startUpdating()
        }
        isLocationEnabled = authorized
    }
    
    func didUpdateLocations(_ location: CLLocation) {
        print(location.coordinate)
        delegate?.locationGathered()
    }
}
