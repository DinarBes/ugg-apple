//
//  OtpState+Dto.swift
//  template-kit
//

import Foundation
import TemplateShared

extension OtpState {
    init(from dto: TemplateShared.OtpState) {
        self.init(
            otp: dto.otp,
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}
