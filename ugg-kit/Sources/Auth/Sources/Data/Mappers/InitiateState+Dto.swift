//
//  InitiateState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension InitiateState {
    init(from dto: UggShared.InitiateState) {
        self.init(
            nationalNumber: dto.phone.hasPrefix("+7") ? String(dto.phone.dropFirst(2)) : dto.phone,
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}
