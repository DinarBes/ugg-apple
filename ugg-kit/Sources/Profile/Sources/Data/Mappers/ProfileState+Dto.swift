//
//  ProfileState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension ProfileState {
    init(from dto: UggShared.ProfileState) {
        self.init(
            profile: dto.profile.map(Profile.init(from:)),
            isGuest: dto.isGuest,
            isLoading: dto.isLoading,
            isRefreshing: dto.isRefreshing,
            error: dto.error?.message
        )
    }
}

extension Profile {
    init(from dto: UggShared.Profile) {
        self.init(
            name: dto.name,
            initials: dto.initials,
            phone: dto.phone,
            activeOrder: dto.activeOrder.map {
                ActiveOrder(
                    number: $0.number,
                    details: $0.details,
                    title: $0.title,
                    description: $0.description_,
                    steps: $0.steps,
                    currentStep: Int($0.currentStep),
                    masterPhotoCount: Int($0.masterPhotoCount)
                )
            },
            size: dto.size,
            ordersSummary: dto.ordersSummary,
            menu: dto.menu.map { MenuItem(kind: MenuItem.Kind(from: $0.kind), title: $0.title) }
        )
    }
}

extension Profile.MenuItem.Kind {
    init(from dto: UggShared.ProfileMenuItem.Kind) {
        self = switch dto {
            case .addresses: .addresses
            case .care: .care
            case .contact: .contact
            case .logout: .logout
        }
    }
}

extension SettingsState {
    init(from dto: UggShared.SettingsState) {
        self.init(
            account: dto.account.map { Account(name: $0.name, phone: $0.phone) },
            version: dto.version,
            isLoading: dto.isLoading,
            isRefreshing: dto.isRefreshing,
            isDeleting: dto.isDeleting,
            error: dto.error?.message
        )
    }
}

extension NameState {
    init(from dto: UggShared.NameState) {
        self.init(name: dto.name, isSaving: dto.isSaving, canSave: dto.canSave, error: dto.error?.message)
    }
}
