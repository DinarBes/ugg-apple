//
//  UggFirebase.swift
//  ugg-kit
//

import Foundation
import FirebaseCore
import FirebaseAuth

import UggShared

/// Firebase for the app: the iOS SDK lives here, and Kotlin reaches it through the bridges
/// (`IosFirestore`, `IosPhoneAuth`) set up by `configure()`.
public enum UggFirebase {
    /// Call once, first thing at launch — before the DI container creates `TemplateApp`.
    /// Reads `GoogleService-Info.plist` from the app bundle.
    @MainActor
    public static func configure() {
        FirebaseApp.configure()
        // The SMS text and the reCAPTCHA page in Russian.
        FirebaseAuth.Auth.auth().languageCode = "ru"

        IosFirestore.shared.bridge = FirestoreBridgeImpl()
        IosPhoneAuth.shared.bridge = PhoneAuthBridgeImpl()
    }

    /// The return from the reCAPTCHA page of the phone sign-in (the `app-1-…` URL scheme).
    /// `true` when Firebase took the URL.
    @MainActor
    @discardableResult
    public static func handle(_ url: URL) -> Bool {
        FirebaseAuth.Auth.auth().canHandle(url)
    }
}
