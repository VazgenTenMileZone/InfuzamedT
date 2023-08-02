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
