//
//  RegistrationState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension RegistrationState {
    init(from dto: UggShared.RegistrationState) {
        self.init(
            name: dto.name,
            isSaving: dto.isSaving,
            canSubmit: dto.canSubmit,
            error: dto.error?.message
        )
    }
}
