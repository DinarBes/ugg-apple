//
//  Container+registerProfileModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerProfileModule() {
        register(ProfileViewModel.self) { resolver in
            ProfileViewModel(app: resolver.resolve(TemplateApp.self)!)
        }

        register(SettingsViewModel.self) { resolver in
            SettingsViewModel(app: resolver.resolve(TemplateApp.self)!)
        }

        register(NameViewModel.self) { resolver in
            NameViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
