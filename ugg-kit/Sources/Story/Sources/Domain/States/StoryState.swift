//
//  StoryState.swift
//  ugg-kit
//

import Foundation

struct StoryState: Hashable, Sendable {
    var story: Story? = nil
    var isLoading: Bool = false
    var error: String? = nil
}

struct Story: Hashable, Sendable {
    var kicker: String
    /// May contain `\n`.
    var title: String
    var intro: String
    var stepsTitle: String
    var steps: [Step]
    /// The blue «Почему Байкал» card; `nil` hides it.
    var highlight: Highlight?

    /// One step of «Путь одной пары».
    struct Step: Identifiable, Hashable, Sendable {
        var id: String { number }

        /// «01».
        var number: String
        var title: String
        var description: String
    }

    struct Highlight: Hashable, Sendable {
        var kicker: String
        var title: String
        var body: String
    }
}
