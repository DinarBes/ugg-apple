//
//  OnboardingState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension OnboardingState {
    init(from dto: UggShared.OnboardingState) {
        self.init(
            slides: dto.slides.map(OnboardingSlide.init(from:)),
            page: Int(dto.page),
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}

extension OnboardingSlide {
    init(from dto: UggShared.OnboardingSlide) {
        self.init(id: dto.id, overline: dto.overline, title: dto.title, description: dto.description_)
    }
}
