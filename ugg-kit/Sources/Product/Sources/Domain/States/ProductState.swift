//
//  ProductState.swift
//  ugg-kit
//

import Foundation

struct ProductState: Hashable, Sendable {
    var product: Product? = nil
    var selection = Selection()
    /// Index in `Product.details`; `nil` — everything collapsed.
    var expandedDetail: Int? = 0
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var error: String? = nil

    /// What the user picked — the future cart line.
    struct Selection: Hashable, Sendable {
        var shadeId: String? = nil
        var heightId: String? = nil
        var size: String? = nil
        var isComplete: Bool = false
    }

    var selectedShade: Product.Shade? { product?.shades.first { $0.id == selection.shadeId } }

    /// «Каштан · 38» under the price; just the color until a size is picked.
    var selectionSummary: String {
        [selectedShade?.name, selection.size].compactMap { $0 }.joined(separator: " · ")
    }
}

struct Product: Hashable, Sendable {
    var id: String
    var kicker: String
    var title: String
    /// Already formatted: «14 900 ₽».
    var price: String
    var leadTime: String
    var description: String
    var photoCount: Int
    var shades: [Shade]
    var heights: [Height]
    var sizes: [Size]
    var customSizeHint: String?
    var features: [Feature]
    var details: [Detail]

    struct Shade: Hashable, Sendable, Identifiable {
        var id: String
        var name: String
        /// 0xRRGGBB.
        var color: UInt64
    }

    struct Height: Hashable, Sendable, Identifiable {
        var id: String
        var name: String
        var value: String
    }

    struct Size: Hashable, Sendable {
        var label: String
        var isAvailable: Bool
    }

    struct Feature: Hashable, Sendable {
        enum Kind: Hashable, Sendable { case material, handmade, warmth, warranty }

        var kind: Kind
        var title: String
        var caption: String
    }

    struct Detail: Hashable, Sendable {
        var title: String
        var body: String
    }
}
