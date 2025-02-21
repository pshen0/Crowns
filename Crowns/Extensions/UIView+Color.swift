//
//  ColorExtension.swift
//  Crowns
//
//  Created by Анна Сазонова on 22.01.2025.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: Double) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        guard hexSanitized.count == 6 && alpha <= 1.0 && alpha >= 0 else {
            self.init(white: 0.0, alpha: 0.0)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
