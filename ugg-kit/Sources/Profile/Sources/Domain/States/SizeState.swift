//
//  SizeState.swift
//  ugg-kit
//

import Foundation

struct SizeState: Hashable, Sendable {
    /// The sizes we sew, from the product: «35» … «42».
    var sizes: [String] = []
    var heights: [HeightOption] = []
    var size: String? = nil
    var heightId: String? = nil
    /// As typed: «24,5».
    var footLength: String = ""
    var footLengthError: String? = nil
    var canSave: Bool = false
    var isLoading: Bool = true
    var isSaving: Bool = false
    var error: String? = nil

    /// «Стандарт · 22 см».
    struct HeightOption: Identifiable, Hashable, Sendable {
        var id: String
        var name: String
        var value: String
    }
}
