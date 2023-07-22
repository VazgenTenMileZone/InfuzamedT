//
//  UIColor+Extension.swift
//  Infuzamed
//
//  Created by Vazgen on 7/12/23.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: HEX
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int & 0xFF, int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(displayP3Red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func darken(by percent: CGFloat) -> UIColor {
           var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
           
           if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
               let newRed = max(0, red - percent)
               let newGreen = max(0, green - percent)
               let newBlue = max(0, blue - percent)
               
               return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
           }
           
           return self
       }
}
