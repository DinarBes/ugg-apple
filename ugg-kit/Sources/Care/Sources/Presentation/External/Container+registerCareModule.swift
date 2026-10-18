//
//  Container+registerCareModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerCareModule() {
        register(CareViewModel.self) { resolver in
            CareViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
