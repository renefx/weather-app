//
//  AppDelegate.swift
//  Weather App
//
//  Created by Renê Xavier on 09/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = LocationManager()
    var location: CLLocation?
    var isLocationEnabled = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.delegate = self
        locationManager.addObserver()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        locationManager.stopUpdatingLocation()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        requestAuthorization()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        locationManager.removeObserver()
    }
    
    func requestAuthorization() {
        isLocationEnabled = locationManager.isLocationEnabled
        if isLocationEnabled && LocationManager.userSwitchEnableGps {
            locationManager.startUpdating()
        } else {
            locationManager.requestAuthorization()
        }
    }


}

extension AppDelegate: LocationDelegate {
    func didChangeAuthorization(_ authorized: Bool) {
        if authorized && !isLocationEnabled && LocationManager.userSwitchEnableGps {
            locationManager.startUpdating()
        }
        isLocationEnabled = authorized
    }
    
    func didUpdateLocations(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else {
                UserDefaults.standard.removeObject(forKey: UserDefaultKeys.cityName)
                return
            }
            UserDefaults.standard.set(placemark.locality, forKey: UserDefaultKeys.cityName)
        }
        
        let location = Coordinate(location.coordinate.latitude, location.coordinate.longitude)
        location.saveCoordinate()
        
        let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
        NotificationCenter.default.post(name: notificationNameForLocationUpdate, object: location, userInfo: nil)
    }
}
