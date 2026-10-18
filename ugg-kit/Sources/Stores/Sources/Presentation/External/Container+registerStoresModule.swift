//
//  Container+registerStoresModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerStoresModule() {
        register(StoresViewModel.self) { resolver in
            StoresViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
