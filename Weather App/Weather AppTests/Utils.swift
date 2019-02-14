//
//  Utils.swift
//  Weather AppTests
//
//  Created by Renê Xavier on 14/02/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

class TestUtil {
    static let stringRegex = "([a-z][A-Z][0-9])+"
    static let double = "[0-9]+(\\.[0-9]+)?"
    
    static func isRegexMatch(regex: String, in text: String?) -> Bool {
        return matches(for: regex, in: text).count > 0
    }
    
    static func matches(for regex: String, in text: String?) -> [String] {
        guard let text = text else { return [] }
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
