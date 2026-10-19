//
//  AppDelegate.swift
//  ugg-apple
//

import UIKit
import Swinject

import UggKitCore
import UggKitFirebase
import UggKitAuth
import UggKitSplash
import UggKitOnboarding
import UggKitHome
import UggKitProduct
import UggKitCart
import UggKitStores
import UggKitProfile
import UggKitCare
import UggKitStory
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
        // Before the container builds TemplateApp: Kotlin picks up Firestore and the sign-in here.
        UggFirebase.configure()

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
        di.registerCareModule()
        di.registerStoryModule()
        di.registerNavigationModule()

        self.di = di
        return true
    }

    // MARK: - Firebase phone sign-in
    //
    // Forwarded by hand: under SwiftUI's delegate adaptor Firebase cannot hook these itself
    // (FirebaseAppDelegateProxyEnabled is off in Info.plist).

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UggFirebase.setAPNSToken(deviceToken)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // The app has no pushes of its own yet: whatever Firebase does not take is ignored.
        UggFirebase.handleNotification(userInfo)
        completionHandler(.noData)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        UggFirebase.handle(url)
    }
}
