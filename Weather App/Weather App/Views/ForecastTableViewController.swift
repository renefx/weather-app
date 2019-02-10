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
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: headerHeight))
        if (section != 0) {
            let topLine = UIView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: lineHeight))
            topLine.backgroundColor = Color.grey
            header.addSubview(topLine)
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: lineHeight, width: self.screenWidth, height:  headerHeight))
        label.backgroundColor = .white
        label.text = "TODAY"
        header.addSubview(label)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: headerHeight - lineHeight, width: self.screenWidth, height: lineHeight))
        bottomLine.backgroundColor = Color.grey
        header.addSubview(bottomLine)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherInformationIdentifier", for: indexPath)
        if let forecastInformationCell = cell as? ForecastTableViewCell {
            
            return forecastInformationCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
