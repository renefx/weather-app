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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
        controller.requestAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.gatherLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateWeatherInformation() {
    }
    
    @IBAction func shareWeather() {
    }
}

extension CurrentWeatherTableViewController: CurrentWeatherControllerDelegate {
    func locationGathered() {
        updateWeatherInformation()
    }
}
