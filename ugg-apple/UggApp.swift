//
//  UggApp.swift
//  ugg-apple
//
//  Created by Archibbald on 16.04.2026.
//

import SwiftUI

import UggKitCore

@main
struct UggApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .dependencyInjection(appDelegate.di)
                .tint(UggColors.content)
        }
    }
}
