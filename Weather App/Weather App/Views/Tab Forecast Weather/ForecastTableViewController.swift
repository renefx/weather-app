//
//  ForecastTableViewController.swift
//  Weather App
//
//  Created by Renê Xavier on 09/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {

    @IBOutlet weak var headerLabel: UILabel!
    let headerHeight: CGFloat = 45
    let lineHeight: CGFloat = 1
    
    private let presenter = ForecastPresenter()
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
        self.navigationItem.title = presenter.navigationBarTitle
        NotificationCenter.default.addObserver(self, selector: #selector(observerForLocationUpdate(notification:)), name: notificationNameForLocationUpdate, object: nil)
        
        tableView.reloadData()
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationNameForLocationUpdate, object: nil)
    }
    
    // MARK: - Selectors
    @objc func observerForLocationUpdate(notification: Notification) {
        guard let coordinate = notification.object as? Coordinate else {
            tableView.reloadData()
            return
        }
        refreshData(coordinate)
    }
    
    @objc func userRefreshForecastData(_ sender: Any) {
        refreshData(showRefresh: false)
    }
    
    // MARK: - Refresh Control
    
    func configureRefreshControl() {
        self.refreshControl = weatherRefreshControl
        weatherRefreshControl.addTarget(self, action: #selector(userRefreshForecastData(_:)), for: .valueChanged)
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
        presenter.refreshForecastWeather(coordinate)
    }

    // MARK: - Table Section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
        let title = presenter.titleForSection(section)
        let header = ForecastSectionHeader(frame: headerFrame, title: title)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !presenter.existForecast { return 0 }
        return headerHeight
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rowsForSection(section)
    }

    // MARK: - Table Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard presenter.existForecast else {
            if let refreshControl = self.refreshControl, refreshControl.isRefreshing {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.loadingForecastIdentifier, for: indexPath)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.noDataAvailableIdentifier, for: indexPath)
            guard let noDataCell = cell as? NoDataTableViewCell else {
                return cell
            }
            
            if presenter.isConnected {
                noDataCell.noDataImage.image = UIImage(named: General.sadImage)
                noDataCell.noDataMessage.text = ErrorMessages.unexpectedError
            } else {
                noDataCell.noDataImage.image = UIImage(named: General.noWifiImage)
                noDataCell.noDataMessage.text = ErrorMessages.noInternet
            }
            
            return noDataCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.weatherInformationIdentifier, for: indexPath)
        guard let forecastInformationCell = cell as? ForecastTableViewCell else {
            return cell
        }
        
        let section = indexPath.section
        let showDivider = indexPath.row != presenter.rowsForSection(section) - 1
        forecastInformationCell.shouldShowDivider(showDivider)
        
        forecastInformationCell.weatherImage.image = UIImage(named: presenter.iconNameForCell(atIndexPath: indexPath))
        forecastInformationCell.weatherTime.text = presenter.timeForCell(atIndexPath: indexPath)
        forecastInformationCell.weatherLabel.text = presenter.weatherTitleForCell(atIndexPath: indexPath)
        forecastInformationCell.temperatureLabel.text = presenter.temperatureForCell(atIndexPath: indexPath)
        
        forecastInformationCell.weatherImage.popUp()
        forecastInformationCell.temperatureLabel.popUp()
        return forecastInformationCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard presenter.existForecast else {
            if let refreshControl = self.refreshControl, refreshControl.isRefreshing {
                return 100
            }
            return 250
        }
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.setDefaultTemperatureScale()
    }
}

// MARK: - ForecastPresenterDelegate
extension ForecastTableViewController: ForecastPresenterDelegate {
    func temperatureScaleChanged() {
        tableView.reloadData()
    }
    
    func forecastUpdated(_ error: RequestErrors?) {
        weatherRefreshControl.endRefreshing()
        tableView.reloadData()
    }
    
}
