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
    
    let controller = CurrentWeatherPresenter()
    let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(observerForLocationUpdate(notification:)), name: notificationNameForLocationUpdate, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationNameForLocationUpdate, object: nil)
    }
    
    // MARK: - IBActions
    @IBAction func shareWeather() {
    }
    
    @IBAction func changeTemperatureScale(_ sender: Any) {
        controller.setDefaultTemperatureScale()
    }
    
    // MARK: - Selectors
    @objc func observerForLocationUpdate(notification: Notification) {
        guard let location = notification.object as? Dictionary<String,Double>,
            let latitude = location[LocationDictionaryKeys.latitude],
            let longitude = location[LocationDictionaryKeys.longitude]  else {
            //TO DO: Add alert
            return
        }
        //TO DO: add loading
        controller.updateWeatherInformation(latitude, longitude)
    }
    
    // MARK: - Updatte Screen
    func updateWeatherInformation() {
        weatherIcon.image = UIImage(named: controller.iconName)
        cityLabel.text = controller.cityFullName
        temperatureLabel.text = controller.temperature
        weatherLabel.text = controller.weatherTitle
        humidityLabel.text = controller.humidity
        precipitationLabel.text = controller.precipitation
        pressureLabel.text = controller.pressure
        windLabel.text = controller.windSpeed
        windDirectionLabel.text = controller.windDirection
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

// MARK: - CurrentWeatherPresenterDelegate
extension CurrentWeatherTableViewController: CurrentWeatherPresenterDelegate {
    func temperatureScaleChanged() {
        temperatureLabel.text = controller.temperature
    }
    
    func weatherUpdated(_ error: String?) {
        //TO DO: remove loading
        guard error == nil else {
            //TO DO: Add alert
            return
        }
        updateWeatherInformation()
    }
}
