//
//  AppDelegate.swift
//  ugg-apple
//

import UIKit
import Swinject

import UggKitCore
import UggKitAuth
import UggKitSplash
import UggKitNavigation

final class AppDelegate: NSObject, UIApplicationDelegate {
    var di: Container!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let di = Container()
        di.registerAppModule()
        di.registerAuthModule()
        di.registerSplashModule()
        di.registerNavigationModule()

        self.di = di
        return true
    }
}
