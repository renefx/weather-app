//
//  NoInternetAlertController.swift
//  Weather App
//
//  Created by Renê Xavier on 13/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class NoInternetAlertController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsAction = UIAlertAction(title: AlertNoInternet.settings, style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        self.addAction(settingsAction)
        
        let okAction = UIAlertAction(title: AlertNoInternet.ok, style: .default, handler: nil)
        self.addAction(okAction)
    }

}
