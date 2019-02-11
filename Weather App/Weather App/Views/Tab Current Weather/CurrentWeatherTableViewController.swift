//
//  CurrentWeatherTableViewController.swift
//  Weather App
//
//  Created by Renê Xavier on 09/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class CurrentWeatherTableViewController: UITableViewController {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    let controller = CurrentWeatherController()
    let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(observerForLocationUpdate(notification:)), name: notificationNameForLocationUpdate, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationNameForLocationUpdate, object: nil)
    }
    
    @IBAction func shareWeather() {
    }
    
    @objc func observerForLocationUpdate(notification: Notification) {
        guard let location = notification.object as? Dictionary<String,Double>,
            let latitude = location[LocationDictionaryKeys.latitude],
            let longitude = location[LocationDictionaryKeys.longitude]  else {
            return
        }
        controller.updateWeatherInformation(latitude, longitude) { (jsonResult) -> () in
            print(jsonResult)
        }
    }
    
    func updateWeatherInformation() {
    }
}
