//
//  Container+registerHomeModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerHomeModule() {
        register(HomeViewModel.self) { resolver in
            HomeViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
