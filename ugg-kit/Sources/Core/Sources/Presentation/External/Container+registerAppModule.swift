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
                app.environment = .mock
                // MOCK swaps the store, not the flow that reads it — see splashDataModule.
                app.keystore = InMemoryKeystore(configuration: KeystoreConfiguration())
                app.core = TemplateCore { core in
                    core.logLevel = .info
                    core.api = .ClientLocalhost()
                }
            }
        }
        .inObjectScope(.container)
    }
}
