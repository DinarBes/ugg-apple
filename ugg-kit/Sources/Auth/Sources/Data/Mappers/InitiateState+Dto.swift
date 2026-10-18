//
//  InitiateState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension InitiateState {
    init(from dto: UggShared.InitiateState) {
        self.init(
            phone: dto.phone,
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}
