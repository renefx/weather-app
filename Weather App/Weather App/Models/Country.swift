//
//  Country.swift
//  Weather App
//
//  Created by Renê Xavier on 11/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct Country: Codable {
    let countryCode: String
    
    private enum CodingKeys: String, CodingKey {
        case countryCode = "country"
    }
}