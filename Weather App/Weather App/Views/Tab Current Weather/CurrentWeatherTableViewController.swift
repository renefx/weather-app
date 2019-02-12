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
    
    private let controller = CurrentWeatherPresenter()
    private let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
    let weatherRefreshControl = UIRefreshControl()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
        configureRefreshControl()
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
        let shareMessage = controller.shareMessage
        let shareImage = UIImage(named: controller.iconName) as Any
        if let shareLink = controller.shareLink {
            let shareArray: [Any] = [shareMessage, shareImage, shareLink]
            let activityViewController = UIActivityViewController(activityItems: shareArray, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion:  nil)
        }
    }
    
    @IBAction func changeTemperatureScale(_ sender: Any) {
        controller.setDefaultTemperatureScale()
    }
    
    // MARK: - Selectors
    @objc func observerForLocationUpdate(notification: Notification) {
        guard let location = notification.object as? Coordinate else {
            //TO DO: Add alert
            return
        }
        
        paintRefreshControl()
        weatherRefreshControl.programaticallyBeginRefreshing(in: tableView)
        controller.updateWeatherInformation(location.latitude, location.longitude)
    }
    
    @objc func userRefreshWeatherData(_ sender: Any) {
        controller.userRefreshWeatherInformation()
    }
    
    // MARK: - Updatte Screen
    func paintRefreshControl() {
        self.refreshControl?.tintColor = controller.isDay ? Color.primary : Color.secondary
    }
    
    func configureRefreshControl() {
        self.refreshControl = weatherRefreshControl
        weatherRefreshControl.addTarget(self, action: #selector(userRefreshWeatherData(_:)), for: .valueChanged)
    }
    
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
        weatherRefreshControl.endRefreshing()
        
        guard error == nil else {
            //TO DO: Add alert
            return
        }
        updateWeatherInformation()
    }
}
