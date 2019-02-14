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
    
    private let presenter = CurrentWeatherPresenter()
    private let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
    private let weatherRefreshControl = UIRefreshControl()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        configureRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(observerForLocationUpdate(notification:)), name: notificationNameForLocationUpdate, object: nil)
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationNameForLocationUpdate, object: nil)
    }
    
    // MARK: - IBActions
    @IBAction func shareWeather() {
        let shareMessage = presenter.shareMessage
        let shareImage = UIImage(named: presenter.iconName) as Any
        let shareLink = presenter.shareLink as Any
        let shareArray: [Any] = [shareMessage, shareImage, shareLink]
        let activityViewController = UIActivityViewController(activityItems: shareArray, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion:  nil)
    }
    
    @IBAction func changeTemperatureScale(_ sender: Any) {
        presenter.setDefaultTemperatureScale()
    }
    
    // MARK: - Selectors
    @objc func observerForLocationUpdate(notification: Notification) {
        guard let coordinate = notification.object as? Coordinate else { return }
        refreshData(coordinate)
    }
    
    @objc func userRefreshWeatherData(_ sender: Any) {
        refreshData(showRefresh: false)
    }
    
    // MARK: - Refresh Control
    func configureRefreshControl() {
        self.refreshControl = weatherRefreshControl
        weatherRefreshControl.addTarget(self, action: #selector(userRefreshWeatherData(_:)), for: .valueChanged)
    }
    
    func paintRefreshControl() {
        self.refreshControl?.tintColor = presenter.isDay ? Color.primary : Color.secondary
    }
    
    // MARK: - Update Screen
    
    func refreshData(_ coordinate: Coordinate? = nil, showRefresh: Bool = true) {
        paintRefreshControl()
        if showRefresh {
            weatherRefreshControl.programaticallyBeginRefreshing(in: tableView)
        }
        presenter.refreshCurrentWeather(coordinate)
    }
    
    func updateViews() {
        weatherIcon.image = UIImage(named: presenter.iconName)
        weatherIcon.popUp()
        
        cityLabel.text = presenter.cityFullName
        temperatureLabel.text = presenter.temperature
        weatherLabel.text = presenter.weatherTitle
        humidityLabel.text = presenter.humidity
        precipitationLabel.text = presenter.precipitation
        pressureLabel.text = presenter.pressure
        windLabel.text = presenter.windSpeed
        windDirectionLabel.text = presenter.windDirection
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

// MARK: - CurrentWeatherPresenterDelegate
extension CurrentWeatherTableViewController: CurrentWeatherPresenterDelegate {
    func temperatureScaleChanged() {
        temperatureLabel.text = presenter.temperature
    }
    
    func weatherUpdated(_ error: RequestErrors?) {
        weatherRefreshControl.endRefreshing()
        updateViews()
        if let error = error, error == .noInternet {
            self.present(NoInternetAlertController(title: AlertNoInternet.title, message: AlertNoInternet.message, preferredStyle: .alert), animated: true, completion: nil)
        }
    }
}
