//
//  StoresState.swift
//  ugg-kit
//

import Foundation

struct StoresState: Hashable, Sendable {
    /// The stores of the selected city (or all).
    var stores: [Store] = []
    var cities: [String] = []
    var totalCount: Int = 0
    /// `nil` — all cities.
    var city: String? = nil
    var selectedStoreId: String? = nil
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var error: String? = nil
}

struct Store: Hashable, Sendable, Identifiable {
    var id: String
    var city: String
    var name: String
    var address: String
    /// «Ежедневно 10:00–20:00».
    var hours: String
    /// Already phrased: «Открыто», «Откроется в пт».
    var status: String
    var isOpen: Bool
    var services: [String]
    var latitude: Double
    var longitude: Double
    /// `tel:` link for «Позвонить»; empty when the store has no phone.
    var phoneUri: String
    /// Route link: Yandex Maps, or the browser when the app is missing.
    var routeUri: String
}
