//
//  OnboardingState.swift
//  ugg-kit
//

import Foundation

struct OnboardingState: Hashable, Sendable {
    var slides: [OnboardingSlide] = []
    var page: Int = 0
    var isLoading: Bool = false
    var error: String? = nil

    var isLastPage: Bool { slides.isEmpty || page >= slides.count - 1 }
}

struct OnboardingSlide: Hashable, Sendable, Identifiable {
    var id: String
    var overline: String
    var title: String
    var description: String
}
