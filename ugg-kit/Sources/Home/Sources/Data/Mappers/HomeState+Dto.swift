//
//  HomeState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension HomeState {
    init(from dto: UggShared.HomeState) {
        self.init(
            home: dto.home.map(Home.init(from:)),
            cartCount: Int(dto.cartCount),
            isLoading: dto.isLoading,
            isRefreshing: dto.isRefreshing,
            error: dto.error?.message
        )
    }
}

extension Home {
    init(from dto: UggShared.Home) {
        self.init(
            hero: Hero(
                kicker: dto.hero.kicker,
                title: dto.hero.title,
                description: dto.hero.description_,
                price: dto.hero.price,
                leadTime: dto.hero.leadTime
            ),
            stats: dto.stats.map { Stat(value: $0.value, caption: $0.caption) },
            shades: dto.shades.map {
                // ARGB from Kotlin; the alpha byte is dropped.
                Shade(id: $0.id, name: $0.name, color: UInt64(bitPattern: $0.color) & 0xFFFFFF, isInStock: $0.isInStock)
            },
            craftSteps: dto.craftSteps.map { CraftStep(number: $0.number, title: $0.title, description: $0.description_) },
            quote: dto.quote.map { Quote(text: $0.text, author: $0.author, role: $0.role) },
            stores: dto.stores.map {
                StorePreview(id: $0.id, city: $0.city, address: $0.address, hours: $0.hours, isOpen: $0.isOpen)
            },
            care: dto.care.map { CareTeaser(kicker: $0.kicker, title: $0.title, readTime: $0.readTime) }
        )
    }
}
