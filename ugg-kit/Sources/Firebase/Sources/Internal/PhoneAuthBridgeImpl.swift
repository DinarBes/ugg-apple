//
//  PhoneAuthBridgeImpl.swift
//  ugg-kit
//

import Foundation
import FirebaseAuth

import UggShared

/// Kotlin's `PhoneAuthBridge` on Firebase Auth. Firebase verifies the app before sending the SMS:
/// with a silent push when APNs is set up, otherwise with a reCAPTCHA page that comes back
/// through the `app-1-…` URL scheme (see `UggFirebase.handle(_:)`).
final class PhoneAuthBridgeImpl: NSObject, PhoneAuthBridge {
    private var auth: FirebaseAuth.Auth { .auth() }

    var currentUser: AuthUser? {
        auth.currentUser.map(Self.user)
    }

    func addUserListener(onChange: @escaping (AuthUser?) -> Void) -> PhoneAuthBridgeRegistration {
        let handle = auth.addStateDidChangeListener { _, user in
            onChange(user.map(Self.user))
        }
        return AuthRegistrationImpl(handle: handle)
    }

    func sendCode(phone: String, completion: @escaping (String?, PhoneAuthBridgeError?) -> Void) {
        // Kotlin calls from a background thread; the reCAPTCHA page has to be shown from the main one.
        DispatchQueue.main.async {
            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationId, error in
                if let error { return completion(nil, Self.bridgeError(error)) }
                completion(verificationId, nil)
            }
        }
    }

    func verify(verificationId: String, code: String, completion: @escaping (AuthUser?, PhoneAuthBridgeError?) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        auth.signIn(with: credential) { result, error in
            if let error { return completion(nil, Self.bridgeError(error)) }
            completion(result.map { Self.user($0.user) }, nil)
        }
    }

    func signOut() {
        try? auth.signOut()
    }

    func deleteAccount(completion: @escaping (PhoneAuthBridgeError?) -> Void) {
        guard let user = auth.currentUser else { return completion(nil) }
        user.delete { error in
            completion(error.map(Self.bridgeError))
        }
    }

    private static func user(_ user: FirebaseAuth.User) -> AuthUser {
        AuthUser(uid: user.uid, phone: user.phoneNumber)
    }

    /// A Firebase Auth error as a `PhoneAuthException.Reason` name.
    private static func bridgeError(_ error: Error) -> PhoneAuthBridgeError {
        let ns = error as NSError
        var reason = "Unknown"
        if ns.domain == "FIRAuthErrorDomain" {
            // `AuthErrorCode` raw values, stable across SDK versions.
            switch ns.code {
                case 17043, 17044: reason = "InvalidCode"
                case 17041, 17042: reason = "InvalidPhone"
                case 17051: reason = "CodeExpired"
                case 17010, 17052: reason = "TooManyRequests"
                case 17020: reason = "Network"
                case 17014: reason = "RecentLoginRequired"
                default: break
            }
        } else if ns.domain == NSURLErrorDomain {
            reason = "Network"
        }
        return PhoneAuthBridgeError(reason: reason, message: ns.localizedDescription)
    }
}

private final class AuthRegistrationImpl: NSObject, PhoneAuthBridgeRegistration {
    private let handle: AuthStateDidChangeListenerHandle

    init(handle: AuthStateDidChangeListenerHandle) {
        self.handle = handle
    }

    func remove() {
        FirebaseAuth.Auth.auth().removeStateDidChangeListener(handle)
    }
}
