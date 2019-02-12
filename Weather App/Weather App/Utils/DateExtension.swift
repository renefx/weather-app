//
//  DateExtension.swift
//  Weather App
//
//  Created by Renê Xavier on 12/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func dayOfWeekToday() -> String? {
        if Calendar.current.isDate(self, inSameDayAs: Date()) {
            return General.today
        }
        return self.dayOfWeek()
    }
}
