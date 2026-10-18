//
//  AppDelegate.swift
//  ugg-apple
//

import UIKit
import Swinject

import UggKitCore
import UggKitAuth
import UggKitSplash
import UggKitOnboarding
import UggKitHome
import UggKitProduct
import UggKitCart
import UggKitStores
import UggKitProfile
import UggKitNavigation

final class AppDelegate: NSObject, UIApplicationDelegate {
    var di: Container!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Before the first view: unregistered fonts silently fall back to the system font.
        UggFonts.register()
        UggAppearance.apply()

        let di = Container()
        di.registerAppModule()
        di.registerAuthModule()
        di.registerSplashModule()
        di.registerOnboardingModule()
        di.registerHomeModule()
        di.registerProductModule()
        di.registerCartModule()
        di.registerStoresModule()
        di.registerProfileModule()
        di.registerNavigationModule()

        self.di = di
        return true
    }
}
