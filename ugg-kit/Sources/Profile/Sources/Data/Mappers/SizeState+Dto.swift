//
//  SizeState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension SizeState {
    init(from dto: UggShared.SizeState) {
        self.init(
            sizes: dto.options.sizes,
            heights: dto.options.heights.map { HeightOption(id: $0.id, name: $0.name, value: $0.value) },
            size: dto.size,
            heightId: dto.heightId,
            footLength: dto.footLength,
            footLengthError: dto.footLengthError,
            canSave: dto.canSave,
            isLoading: dto.isLoading,
            isSaving: dto.isSaving,
            error: dto.error?.message
        )
    }
}
