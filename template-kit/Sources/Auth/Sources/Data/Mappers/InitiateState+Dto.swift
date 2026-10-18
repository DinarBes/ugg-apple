//
//  InitiateState+Dto.swift
//  template-kit
//

import Foundation
import TemplateShared

extension InitiateState {
    init(from dto: TemplateShared.InitiateState) {
        self.init(
            phone: dto.phone,
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}
