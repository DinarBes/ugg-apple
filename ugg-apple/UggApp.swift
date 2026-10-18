//
//  UggApp.swift
//  ugg-apple
//
//  Created by Archibbald on 16.04.2026.
//

import SwiftUI

import UggKitCore
import UggKitFirebase

@main
struct UggApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .dependencyInjection(appDelegate.di)
                .tint(UggColors.content)
                // The reCAPTCHA page of the phone sign-in returns here.
                .onOpenURL { UggFirebase.handle($0) }
        }
    }
}
