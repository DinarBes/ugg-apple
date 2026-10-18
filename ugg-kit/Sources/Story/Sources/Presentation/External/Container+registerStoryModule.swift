//
//  Container+registerStoryModule.swift
//  ugg-kit
//

import Swinject
import Foundation

import UggShared

@MainActor
public extension Container {
    func registerStoryModule() {
        register(StoryViewModel.self) { resolver in
            StoryViewModel(app: resolver.resolve(TemplateApp.self)!)
        }
    }
}
