//
//  SettingsState.swift
//  ugg-kit
//

import Foundation

struct SettingsState: Hashable, Sendable {
    /// `nil` — a guest.
    var account: Account? = nil
    /// «Версия 1.0 (1)».
    var version: String = ""
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var isDeleting: Bool = false
    var error: String? = nil

    struct Account: Hashable, Sendable {
        /// Empty until the user gives one.
        var name: String
        /// «+7 900 123-45-67».
        var phone: String
    }
}

struct NameState: Hashable, Sendable {
    var name: String = ""
    var isSaving: Bool = false
    var canSave: Bool = false
    var error: String? = nil
}
