//
//  Container+registerNavigationModule.swift
//  template-kit
//
//  Created by Archibbald on 17.04.2026.
//

import Swinject
import Foundation

import TemplateShared

@MainActor
public extension Container {
    func registerNavigationModule() {
        register(NavigationGraphViewModel.self) { resolver in
            NavigationGraphViewModel(app: resolver.resolve(TemplateApp.self)!)
        }

        register(AppTabViewModel.self) { resolver in
            AppTabViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
