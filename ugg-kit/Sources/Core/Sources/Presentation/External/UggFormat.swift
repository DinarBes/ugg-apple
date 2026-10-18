//
//  UggFormat.swift
//  ugg-kit
//

import Foundation

/// Display formatting shared by the screens. Display only — values sent to KMM stay raw.
public enum UggFormat {
    /// «+79001234567» → «+7 900 123-45-67»; anything else is returned as is.
    public static func phone(_ phone: String) -> String {
        guard phone.hasPrefix("+7") else { return phone }
        return "+7 " + nationalNumber(String(phone.dropFirst(2)))
    }

    /// Up to ten digits after «+7», grouped as they are typed: «900 123-45-67».
    public static func nationalNumber(_ digits: String) -> String {
        var result = ""
        for (index, digit) in digits.prefix(10).enumerated() {
            switch index {
                case 3: result += " "
                case 6, 8: result += "-"
                default: break
            }
            result.append(digit)
        }
        return result
    }
}
