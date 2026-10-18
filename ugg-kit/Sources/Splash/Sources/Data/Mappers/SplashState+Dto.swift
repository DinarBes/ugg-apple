//
//  SplashState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension SplashState {
    init(from dto: UggShared.SplashState) {
        self.init(error: dto.error?.message)
    }
}
