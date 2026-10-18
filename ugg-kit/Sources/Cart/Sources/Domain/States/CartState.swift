//
//  CartState.swift
//  ugg-kit
//

import Foundation

struct CartState: Hashable, Sendable {
    var cart: Cart? = nil
    var error: String? = nil
    var isCheckingOut: Bool = false
    /// Set once an order is placed: the screen shows «Заказ № … оформлен».
    var placedOrderNumber: Int64? = nil
    /// A guest pressed «Оформить заказ»: the screen opens the sign-in, then clears this.
    var isSignInRequired: Bool = false
}

struct Cart: Hashable, Sendable {
    var lines: [Line]
    /// Accessories not in the cart yet.
    var extras: [Extra]
    var deliveryOptions: [DeliveryOption]
    var selectedDeliveryId: String?
    var isGiftWrapped: Bool
    var giftWrapTitle: String
    var giftWrapDescription: String
    var summary: [SummaryRow]
    /// «14 900 ₽».
    var total: String
    /// «1 товар · 14 900 ₽».
    var subtitle: String

    var isEmpty: Bool { lines.isEmpty }

    struct Line: Hashable, Sendable, Identifiable {
        var id: String
        var title: String
        var details: String
        /// Line total, formatted.
        var price: String
        var quantity: Int
        var isExtra: Bool
        /// 0xRRGGBB of the sheepskin; `nil` for accessories.
        var color: UInt64?
    }

    struct Extra: Hashable, Sendable, Identifiable {
        var id: String
        var title: String
        var price: String
    }

    struct DeliveryOption: Hashable, Sendable, Identifiable {
        var id: String
        var title: String
        var description: String
        var price: String
    }

    struct SummaryRow: Hashable, Sendable {
        var title: String
        var value: String
    }
}
