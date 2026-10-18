//
//  FirestoreBridgeImpl.swift
//  ugg-kit
//

import Foundation
import FirebaseFirestore

import UggShared

/// Kotlin's `FirestoreBridge` on the Firestore iOS SDK. Documents cross as JSON (see the Kotlin
/// side for the format); the SDK keeps its offline cache, as on Android.
final class FirestoreBridgeImpl: NSObject, FirestoreBridge {
    private let db = Firestore.firestore()

    func getDocument(path: String, completion: @escaping (String?, FirestoreBridgeError?) -> Void) {
        db.document(path).getDocument { snapshot, error in
            if let error { return completion(nil, FirestoreErrors.bridge(error)) }
            Self.deliver(completion) { try FirestoreJSON.document(snapshot) }
        }
    }

    func runQuery(queryJson: String, completion: @escaping (String?, FirestoreBridgeError?) -> Void) {
        let query: FirebaseFirestore.Query
        do { query = try makeQuery(queryJson) } catch { return completion(nil, FirestoreErrors.bridge(error)) }

        query.getDocuments { snapshot, error in
            if let error { return completion(nil, FirestoreErrors.bridge(error)) }
            Self.deliver(completion) { try FirestoreJSON.documents(snapshot) }
        }
    }

    func observeDocument(path: String, onChange: @escaping (String?, FirestoreBridgeError?) -> Void) -> FirestoreBridgeRegistration {
        let registration = db.document(path).addSnapshotListener { snapshot, error in
            if let error { return onChange(nil, FirestoreErrors.bridge(error)) }
            Self.deliver(onChange) { try FirestoreJSON.document(snapshot) }
        }
        return RegistrationImpl(registration)
    }

    func observeQuery(queryJson: String, onChange: @escaping (String?, FirestoreBridgeError?) -> Void) -> FirestoreBridgeRegistration {
        let query: FirebaseFirestore.Query
        do {
            query = try makeQuery(queryJson)
        } catch {
            onChange(nil, FirestoreErrors.bridge(error))
            return RegistrationImpl(nil)
        }

        let registration = query.addSnapshotListener { snapshot, error in
            if let error { return onChange(nil, FirestoreErrors.bridge(error)) }
            Self.deliver(onChange) { try FirestoreJSON.documents(snapshot) }
        }
        return RegistrationImpl(registration)
    }

    func setDocument(path: String, dataJson: String, merge: Bool, completion: @escaping (FirestoreBridgeError?) -> Void) {
        let data: [String: Any]
        do { data = try FirestoreJSON.data(dataJson) } catch { return completion(FirestoreErrors.bridge(error)) }

        db.document(path).setData(data, merge: merge) { error in
            completion(error.map(FirestoreErrors.bridge))
        }
    }

    func deleteDocument(path: String, completion: @escaping (FirestoreBridgeError?) -> Void) {
        db.document(path).delete { error in
            completion(error.map(FirestoreErrors.bridge))
        }
    }

    func generateId(collection: String) -> String {
        db.collection(collection).document().documentID
    }

    func runTransaction(
        body: @escaping (FirestoreBridgeTransaction) -> FirestoreBridgeError?,
        completion: @escaping (FirestoreBridgeError?) -> Void
    ) {
        let db = db
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            if let error = body(TransactionImpl(db: db, transaction: transaction)) {
                errorPointer?.pointee = FirestoreErrors.nsError(error)
            }
            return nil
        }, completion: { _, error in
            completion(error.map(FirestoreErrors.bridge))
        })
    }

    // MARK: - Helpers

    private static func deliver(_ callback: (String?, FirestoreBridgeError?) -> Void, _ encode: () throws -> String?) {
        do {
            callback(try encode(), nil)
        } catch {
            callback(nil, FirestoreErrors.bridge(error))
        }
    }

    private func makeQuery(_ json: String) throws -> FirebaseFirestore.Query {
        guard let object = try JSONSerialization.jsonObject(with: Data(json.utf8)) as? [String: Any],
              let collection = object["collection"] as? String
        else { throw FirestoreJSON.Failure.malformed }

        var query: FirebaseFirestore.Query = db.collection(collection)
        for filter in object["filters"] as? [[String: Any]] ?? [] {
            guard let field = filter["field"] as? String, let op = filter["op"] as? String else { continue }
            let value = FirestoreJSON.firestoreValue(filter["value"] ?? NSNull())
            switch op {
                case "in": query = query.whereField(field, in: value as? [Any] ?? [])
                case "not-in": query = query.whereField(field, notIn: value as? [Any] ?? [])
                default: query = query.whereField(field, isEqualTo: value)
            }
        }
        if let orderBy = object["orderBy"] as? String {
            query = query.order(by: orderBy, descending: object["descending"] as? Bool ?? false)
        }
        if let limit = object["limit"] as? NSNumber {
            query = query.limit(to: limit.intValue)
        }
        return query
    }
}

/// Kotlin's synchronous `FirestoreBridgeTransaction` over the SDK's transaction.
private final class TransactionImpl: NSObject, FirestoreBridgeTransaction {
    private let db: Firestore
    private let transaction: FirebaseFirestore.Transaction

    init(db: Firestore, transaction: FirebaseFirestore.Transaction) {
        self.db = db
        self.transaction = transaction
    }

    func getDocument(path: String) -> FirestoreBridgeResult {
        do {
            let snapshot = try transaction.getDocument(db.document(path))
            return FirestoreBridgeResult(json: try FirestoreJSON.document(snapshot), error: nil)
        } catch {
            return FirestoreBridgeResult(json: nil, error: FirestoreErrors.bridge(error))
        }
    }

    func setDocument(path: String, dataJson: String) {
        // The JSON comes from Kotlin's own encoder; it does not fail to parse.
        guard let data = try? FirestoreJSON.data(dataJson) else { return }
        transaction.setData(data, forDocument: db.document(path))
    }
}

private final class RegistrationImpl: NSObject, FirestoreBridgeRegistration {
    private let registration: ListenerRegistration?

    init(_ registration: ListenerRegistration?) {
        self.registration = registration
    }

    func remove() {
        registration?.remove()
    }
}

// MARK: - Errors

enum FirestoreErrors {
    private static let domain = "UggFirestoreBridge"
    private static let reasonKey = "reason"

    /// A Firestore (or network, or JSON) error as a `FirestoreException.Reason` name.
    static func bridge(_ error: Error) -> FirestoreBridgeError {
        let ns = error as NSError
        print("[UggFirebase] Firestore error \(ns.domain) \(ns.code): \(ns.localizedDescription)")
        let reason: String
        switch ns.domain {
            case domain:
                reason = ns.userInfo[reasonKey] as? String ?? "Unknown"
            case "FIRFirestoreErrorDomain":
                // gRPC status codes, the same on every platform.
                reason = switch ns.code {
                    case 5: "NotFound"
                    case 7: "PermissionDenied"
                    case 16: "Unauthenticated"
                    case 4, 14: "Unavailable"
                    default: "Unknown"
                }
            case NSURLErrorDomain:
                reason = "Unavailable"
            default:
                reason = error is FirestoreJSON.Failure ? "Malformed" : "Unknown"
        }
        return FirestoreBridgeError(reason: reason, message: ns.localizedDescription)
    }

    /// Kotlin's error back as an `NSError`, to abort a transaction with.
    static func nsError(_ error: FirestoreBridgeError) -> NSError {
        NSError(domain: domain, code: 0, userInfo: [reasonKey: error.reason, NSLocalizedDescriptionKey: error.message])
    }
}
