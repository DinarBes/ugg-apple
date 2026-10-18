//
//  UggIcon.swift
//  ugg-kit
//

import SwiftUI

/// The icon set of the design (`UggIcons` on Android), drawn with SF Symbols so they sit right
/// next to system controls and follow Dynamic Type and bold text.
public enum UggIcon: String, CaseIterable, Sendable {
    case arrowRight = "arrow.right"
    case arrowLeft = "arrow.left"
    case heart = "heart"
    case bag = "bag"
    case pin = "mappin.and.ellipse"
    case clock = "clock"
    case home = "house"
    case boot = "shoeprints.fill"
    case user = "person"
    case share = "square.and.arrow.up"
    case chevronDown = "chevron.down"
    case chevronUp = "chevron.up"
    case chevronRight = "chevron.right"
    case ruler = "ruler"
    case leaf = "leaf"
    case scissors = "scissors"
    case snowflake = "snowflake"
    case shieldCheck = "checkmark.shield"
    case plus = "plus"
    case minus = "minus"
    case gift = "gift"
    case settings = "gearshape"
    case package = "shippingbox"
    case message = "bubble.left"
    case logout = "rectangle.portrait.and.arrow.right"
    case check = "checkmark"

    public var image: Image {
        Image(systemName: rawValue)
    }
}
