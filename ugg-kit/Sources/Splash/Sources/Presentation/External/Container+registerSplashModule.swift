//
//  Container+registerSplashModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerSplashModule() {
        register(SplashViewModel.self) { resolver in
            SplashViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
