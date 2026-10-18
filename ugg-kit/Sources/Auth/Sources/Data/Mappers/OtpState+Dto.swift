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
            isResending: dto.isResending,
            resendCount: Int(dto.resendCount),
            error: dto.error?.message
        )
    }
}
