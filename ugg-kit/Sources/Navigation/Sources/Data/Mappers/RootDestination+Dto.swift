//
//  RootDestination+Dto.swift
//  ugg-kit
//

import Foundation

import UggShared

extension RootDestination {
    init(from dto: UggShared.SplashFlow) {
        self = switch onEnum(of: dto) {
            case .onboarding:
                .onboarding
            case .auth:
                .auth
            case .launch:
                .launch
            case .registration:
                .registration
        }
    }
}
