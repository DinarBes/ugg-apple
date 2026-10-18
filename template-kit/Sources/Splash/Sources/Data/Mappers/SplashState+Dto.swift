//
//  SplashState+Dto.swift
//  template-kit
//

import Foundation
import TemplateShared

extension SplashState {
    init(from dto: TemplateShared.SplashState) {
        self.init(error: dto.error?.message)
    }
}
