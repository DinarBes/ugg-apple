//
//  CareState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension CareState {
    init(from dto: UggShared.CareState) {
        self.init(care: dto.care.map(Care.init(from:)), isLoading: dto.isLoading, error: dto.error?.message)
    }
}

extension Care {
    init(from dto: UggShared.Care) {
        self.init(
            kicker: dto.kicker,
            title: dto.title,
            intro: dto.intro,
            readTime: dto.readTime,
            tips: dto.tips.map { Tip(kind: Tip.Kind(from: $0.kind), title: $0.title, body: $0.body) },
            dontsTitle: dto.dontsTitle,
            donts: dto.donts,
            contact: dto.contact.map { Contact(title: $0.title, body: $0.body, button: $0.button) }
        )
    }
}

extension Care.Tip.Kind {
    init(from dto: UggShared.CareTip.Kind) {
        self = switch dto {
            case .snow: .snow
            case .drying: .drying
            case .salt: .salt
            case .cleaning: .cleaning
            case .protection: .protection
            case .storage: .storage
            case .other: .other
        }
    }
}
