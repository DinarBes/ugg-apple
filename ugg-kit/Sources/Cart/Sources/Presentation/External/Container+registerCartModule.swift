//
//  Container+registerCartModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerCartModule() {
        register(CartViewModel.self) { resolver in
            CartViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
