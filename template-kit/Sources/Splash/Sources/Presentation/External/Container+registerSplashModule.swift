//
//  Container+registerSplashModule.swift
//  template-kit
//

import Swinject
import Foundation

import TemplateShared

@MainActor
public extension Container {
    func registerSplashModule() {
        register(SplashViewModel.self) { resolver in
            SplashViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
