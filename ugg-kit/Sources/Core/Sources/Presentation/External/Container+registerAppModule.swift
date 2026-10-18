//
//  Container+registerAppModule.swift
//  ugg-kit
//
//  Created by Archibbald on 17.04.2026.
//

import Swinject
import Foundation

import UggShared

public extension Container {
    func registerAppModule() {
        register(TemplateApp.self) { _ in
            TemplateApp { app in
                // Firestore and the phone sign-in through UggFirebase; the keystore is the
                // default Keychain one, so «onboarding seen» survives a restart.
                // For the bundled mock data: `.mock` and an `InMemoryKeystore`.
                app.environment = .production
                app.appInfo = AppInfo(
                    versionName: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                    versionCode: Int32(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "") ?? 0
                )
                app.core = TemplateCore { core in
                    core.logLevel = .info
                    core.api = .ClientLocalhost()
                }
            }
        }
        .inObjectScope(.container)
    }
}
