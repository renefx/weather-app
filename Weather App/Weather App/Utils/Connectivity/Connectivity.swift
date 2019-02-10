//
//  Connectivity.swift
//  Weather App
//
//  Created by Renê Xavier on 10/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        guard let networkReachabilityManager = NetworkReachabilityManager() else {
            return false
        }
        return networkReachabilityManager.isReachable
    }
}
