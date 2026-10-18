//
//  CareState.swift
//  ugg-kit
//

import Foundation

struct CareState: Hashable, Sendable {
    var care: Care? = nil
    var isLoading: Bool = false
    var error: String? = nil
}

struct Care: Hashable, Sendable {
    var kicker: String
    /// May contain `\n`.
    var title: String
    var intro: String
    /// «3 минуты чтения».
    var readTime: String
    var tips: [Tip]
    var dontsTitle: String
    var donts: [String]
    /// The dark card at the bottom; `nil` hides it.
    var contact: Contact?

    struct Tip: Hashable, Sendable {
        enum Kind: Hashable, Sendable {
            case snow, drying, salt, cleaning, protection, storage, other
        }

        var kind: Kind
        var title: String
        var body: String
    }

    struct Contact: Hashable, Sendable {
        var title: String
        var body: String
        var button: String
    }
}
