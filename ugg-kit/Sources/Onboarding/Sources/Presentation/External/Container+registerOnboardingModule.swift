//
//  Container+registerOnboardingModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerOnboardingModule() {
        register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
