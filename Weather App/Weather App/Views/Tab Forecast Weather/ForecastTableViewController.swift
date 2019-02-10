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
    
    let controller = ForecastController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: ForecastSectionHeader
        let headerFrame = CGRect(x: 0, y: 0, width: self.screenWidth, height: headerHeight)
        let hideTopLine = section != 0
        header = ForecastSectionHeader(frame: headerFrame, title: "TODAY", hideTopLine: hideTopLine)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherInformationIdentifier", for: indexPath)
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
