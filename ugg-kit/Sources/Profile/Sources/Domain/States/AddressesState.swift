//
//  AddressesState.swift
//  ugg-kit
//

import Foundation

struct Address: Identifiable, Hashable, Sendable {
    var id: String
    /// «Иркутск, ул. Ленина, 12, кв. 5».
    var summary: String
    /// For the courier: entrance, floor, intercom.
    var comment: String
    var isDefault: Bool
}

struct AddressesState: Hashable, Sendable {
    var addresses: [Address] = []
    var isLoading: Bool = false
    var isRefreshing: Bool = false
    var error: String? = nil
}

struct AddressFormState: Hashable, Sendable {
    var city: String = ""
    var street: String = ""
    var flat: String = ""
    var comment: String = ""
    var isDefault: Bool = false
    /// Editing a saved address: the form offers «Удалить адрес».
    var isExisting: Bool = false
    /// Shown only after the first «Сохранить».
    var cityError: String? = nil
    var streetError: String? = nil
    var isLoading: Bool = false
    var isSaving: Bool = false
    var error: String? = nil
}
