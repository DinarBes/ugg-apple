//
//  OtpState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension OtpState {
    init(from dto: UggShared.OtpState) {
        self.init(
            otp: dto.otp,
            isLoading: dto.isLoading,
            error: dto.error?.message
        )
    }
}
