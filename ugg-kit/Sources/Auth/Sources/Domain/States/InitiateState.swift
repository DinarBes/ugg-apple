//
//  InitiateState.swift
//  ugg-kit
//

import Foundation

struct InitiateState: Hashable, Sendable {
    /// The ten digits after «+7» the field edits; KMM keeps the full number.
    var nationalNumber: String = ""
    var isLoading: Bool = false
    var error: String? = nil

    var isComplete: Bool { nationalNumber.count == 10 }
}
