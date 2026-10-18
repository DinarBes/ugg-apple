//
//  ProfileState.swift
//  ugg-kit
//

import Foundation

struct ProfileState: Hashable, Sendable {
    var profile: Profile? = nil
    /// Nobody is signed in: the screen offers to sign in instead of the profile.
    var isGuest: Bool = false
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var error: String? = nil
}

struct Profile: Hashable, Sendable {
    var name: String
    /// «АК» for the avatar.
    var initials: String
    /// Already formatted: «+7 900 000-00-00».
    var phone: String
    var activeOrder: ActiveOrder?
    /// «38 · стандарт»; `nil` until the user picks or measures a size.
    var size: String?
    /// «1 активный».
    var ordersSummary: String
    var menu: [MenuItem]

    struct ActiveOrder: Hashable, Sendable {
        /// «Заказ № 1024».
        var number: String
        /// «Каштан · 38».
        var details: String
        var title: String
        var description: String
        /// «Принят», «Раскрой», «Пошив», «Готов».
        var steps: [String]
        /// Index of the stage in progress; earlier ones are done.
        var currentStep: Int
        var masterPhotoCount: Int
    }

    struct MenuItem: Hashable, Sendable {
        enum Kind: Hashable, Sendable { case addresses, care, contact, logout }

        var kind: Kind
        var title: String
    }
}
