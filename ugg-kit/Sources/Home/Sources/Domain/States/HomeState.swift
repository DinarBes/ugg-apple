//
//  HomeState.swift
//  ugg-kit
//

import Foundation

struct HomeState: Hashable, Sendable {
    var home: Home? = nil
    /// Units in the cart — the dot on the bag.
    var cartCount: Int = 0
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var error: String? = nil
}

/// Everything the home screen shows, section by section.
struct Home: Hashable, Sendable {
    var hero: Hero
    var stats: [Stat]
    var shades: [Shade]
    var craftSteps: [CraftStep]
    var quote: Quote?
    var stores: [StorePreview]
    var care: CareTeaser?

    struct Hero: Hashable, Sendable {
        var kicker: String
        var title: String
        var description: String
        /// Already formatted: «14 900 ₽».
        var price: String
        var leadTime: String
    }

    struct Stat: Hashable, Sendable {
        var value: String
        var caption: String
    }

    struct Shade: Hashable, Sendable, Identifiable {
        var id: String
        var name: String
        /// 0xRRGGBB.
        var color: UInt64
        var isInStock: Bool
    }

    struct CraftStep: Hashable, Sendable {
        var number: String
        var title: String
        var description: String
    }

    struct Quote: Hashable, Sendable {
        var text: String
        var author: String
        var role: String
    }

    struct StorePreview: Hashable, Sendable, Identifiable {
        var id: String
        var city: String
        var address: String
        /// Already phrased: «до 20:00», «откроется в пт».
        var hours: String
        var isOpen: Bool
    }

    struct CareTeaser: Hashable, Sendable {
        var kicker: String
        var title: String
        var readTime: String
    }
}
