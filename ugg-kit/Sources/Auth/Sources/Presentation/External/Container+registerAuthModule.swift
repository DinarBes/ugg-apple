//
//  Container+registerAuthModule.swift
//  ugg-kit
//
//  Created by Archibbald on 17.04.2026.
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerAuthModule() {
        register(InitiateViewModel.self) { resolver in
            InitiateViewModel(app: resolver.resolve(TemplateApp.self)!)
        }

        register(OtpViewModel.self) { resolver in
            OtpViewModel(app: resolver.resolve(TemplateApp.self)!)
        }

        register(RegistrationViewModel.self) { resolver in
            RegistrationViewModel(app: resolver.resolve(TemplateApp.self)!)
        }

        register(NavigationViewModel.self) { resolver in
            NavigationViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
