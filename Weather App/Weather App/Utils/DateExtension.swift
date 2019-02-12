//
//  DateExtension.swift
//  Weather App
//
//  Created by Renê Xavier on 12/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

extension Date {
    var dayOfWeek: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self).uppercased()
        }
    }
    
    var dayOfWeekToday: String? {
        get {
            if Calendar.current.isDate(self, inSameDayAs: Date()) {
                return General.today
            }
            return self.dayOfWeek
        }
    }
    
    var hourMinutes: String {
        get {
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: self)
            if let hour = comp.hour, let minute = comp.minute {
                return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
            } else if let hour = comp.hour {
                return "\(String(format: "%02d", hour)):\(00)"
            }
            return General.noTime
        }
    }
}
