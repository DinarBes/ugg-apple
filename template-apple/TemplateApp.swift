//
//  TemplateApp.swift
//  template-apple
//
//  Created by Archibbald on 16.04.2026.
//

import SwiftUI

import TemplateKitCore

@main
struct TemplateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .dependencyInjection(appDelegate.di)
        }
    }
}
