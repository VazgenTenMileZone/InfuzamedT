//
//  Date+Extension.swift
//  Trebel
//
//  Created by Ruben Nahatakyan on 11/3/20.
//  Copyright © 2020 M&M MEDIA, INC. All rights reserved.
//

import Foundation


extension Date {
    func dateToISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return formatter.string(from: self)
    }
}


extension String {
    func toISO8601() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.timeZone = TimeZone.current // Adjust this if needed

        guard let date = inputFormatter.date(from: self) else { return nil }

        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return iso8601Formatter.string(from: date)
    }
}
