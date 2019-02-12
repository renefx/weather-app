//
//  ForecastTableViewController.swift
//  Weather App
//
//  Created by Renê Xavier on 09/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    let headerHeight: CGFloat = 45
    let lineHeight: CGFloat = 1
    
    private let controller = ForecastPresenter()
    private let notificationNameForLocationUpdate = Notification.Name(NotificationNames.locationUpdated)
    private let weatherRefreshControl = UIRefreshControl()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
        configureRefreshControl()
        self.navigationItem.title = controller.navigationBarTitle
        
        paintRefreshControl()
        weatherRefreshControl.programaticallyBeginRefreshing(in: tableView)
        controller.userRefreshWeatherInformation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(observerForLocationUpdate(notification:)), name: notificationNameForLocationUpdate, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationNameForLocationUpdate, object: nil)
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
    
    // MARK: - Update Screen
    func paintRefreshControl() {
        self.refreshControl?.tintColor = controller.isDay ? Color.primary : Color.secondary
    }
    
    func configureRefreshControl() {
        self.refreshControl = weatherRefreshControl
        weatherRefreshControl.addTarget(self, action: #selector(userRefreshWeatherData(_:)), for: .valueChanged)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
        let title = controller.titleForSection(section)
        let header = ForecastSectionHeader(frame: headerFrame, title: title)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return controller.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.rowsForSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.weatherInformationIdentifier, for: indexPath)
        guard let forecastInformationCell = cell as? ForecastTableViewCell else {
            return cell
        }
        
        let indexOfLastCell = tableView.numberOfRows(inSection: indexPath.section) - 1
        let showDivider = indexPath.row != indexOfLastCell
        forecastInformationCell.shouldShowDivider(showDivider)
        return forecastInformationCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - CurrentWeatherPresenterDelegate
extension ForecastTableViewController: ForecastPresenterDelegate {
    func forecastUpdated(_ error: String?) {
        weatherRefreshControl.endRefreshing()
        
        guard error == nil else {
            //TO DO: Add alert
            return
        }
        tableView.reloadData()
    }
    
}
