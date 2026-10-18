//
//  CartState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension CartState {
    init(from dto: UggShared.CartState) {
        self.init(
            cart: dto.cart.map(Cart.init(from:)),
            error: dto.error?.message,
            isCheckingOut: dto.isCheckingOut,
            placedOrderNumber: dto.placedOrderNumber?.int64Value,
            isSignInRequired: dto.isSignInRequired
        )
    }
}

extension Cart {
    init(from dto: UggShared.Cart) {
        self.init(
            lines: dto.lines.map {
                Line(
                    id: $0.id,
                    title: $0.title,
                    details: $0.details,
                    price: $0.price,
                    quantity: Int($0.quantity),
                    isExtra: $0.isExtra,
                    color: $0.color.map { UInt64(bitPattern: $0.int64Value) & 0xFFFFFF }
                )
            },
            extras: dto.extras.map { Extra(id: $0.id, title: $0.title, price: $0.price) },
            deliveryOptions: dto.deliveryOptions.map {
                DeliveryOption(id: $0.id, title: $0.title, description: $0.description_, price: $0.price)
            },
            selectedDeliveryId: dto.selectedDeliveryId,
            isGiftWrapped: dto.isGiftWrapped,
            giftWrapTitle: dto.giftWrapTitle,
            giftWrapDescription: dto.giftWrapDescription,
            summary: dto.summary.map { SummaryRow(title: $0.title, value: $0.value) },
            total: dto.total,
            subtitle: dto.subtitle
        )
    }
}
