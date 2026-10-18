//
//  StoryState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension StoryState {
    init(from dto: UggShared.StoryState) {
        self.init(story: dto.story.map(Story.init(from:)), isLoading: dto.isLoading, error: dto.error?.message)
    }
}

extension Story {
    init(from dto: UggShared.Story) {
        self.init(
            kicker: dto.kicker,
            title: dto.title,
            intro: dto.intro,
            stepsTitle: dto.stepsTitle,
            steps: dto.steps.map { Step(number: $0.number, title: $0.title, description: $0.description_) },
            highlight: dto.highlight.map { Highlight(kicker: $0.kicker, title: $0.title, body: $0.body) }
        )
    }
}
