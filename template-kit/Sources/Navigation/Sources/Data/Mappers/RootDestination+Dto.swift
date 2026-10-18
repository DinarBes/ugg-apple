//
//  RootDestination+Dto.swift
//  template-kit
//

import Foundation

import TemplateShared

extension RootDestination {
    init(from dto: TemplateShared.SplashFlow) {
        self = switch onEnum(of: dto) {
            case .auth:
                .auth
            case .launch:
                .launch
        }
    }
}
