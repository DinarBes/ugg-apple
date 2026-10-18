//
//  Container+registerProductModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerProductModule() {
        register(ProductViewModel.self) { resolver in
            ProductViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
