//
//  FirestoreJSON.swift
//  ugg-kit
//

import Foundation
import FirebaseFirestore

/// Firestore values ⇄ the JSON Kotlin reads and writes: timestamps as epoch milliseconds,
/// geo points as `{"latitude", "longitude"}`, `{"__serverTimestamp": true}` for the server's time.
enum FirestoreJSON {
    enum Failure: Error {
        case malformed
    }

    private static let serverTimestamp = "__serverTimestamp"

    // MARK: Reading

    /// `{"id", "data"}`, or `nil` for a missing document.
    static func document(_ snapshot: DocumentSnapshot?) throws -> String? {
        guard let snapshot, snapshot.exists else { return nil }
        return try string(object(id: snapshot.documentID, data: snapshot.data(with: .estimate) ?? [:]))
    }

    static func documents(_ snapshot: QuerySnapshot?) throws -> String {
        let documents = snapshot?.documents ?? []
        return try string(documents.map { object(id: $0.documentID, data: $0.data(with: .estimate)) })
    }

    private static func object(id: String, data: [String: Any]) -> [String: Any] {
        ["id": id, "data": data.mapValues(plainValue)]
    }

    private static func plainValue(_ value: Any) -> Any {
        switch value {
            case let timestamp as Timestamp:
                return NSNumber(value: Int64(timestamp.seconds) * 1000 + Int64(timestamp.nanoseconds) / 1_000_000)
            case let date as Date:
                return NSNumber(value: Int64(date.timeIntervalSince1970 * 1000))
            case let point as GeoPoint:
                return ["latitude": point.latitude, "longitude": point.longitude]
            case let reference as DocumentReference:
                return reference.path
            case let data as Data:
                return data.base64EncodedString()
            case let map as [String: Any]:
                return map.mapValues(plainValue)
            case let list as [Any]:
                return list.map(plainValue)
            case let number as NSNumber where number.doubleValue.isNaN || number.doubleValue.isInfinite:
                // Not representable in JSON.
                return NSNull()
            default:
                return value
        }
    }

    private static func string(_ object: Any) throws -> String {
        // JSONSerialization raises an Objective-C exception on what it cannot encode — check first.
        guard JSONSerialization.isValidJSONObject(object) else { throw Failure.malformed }
        let data = try JSONSerialization.data(withJSONObject: object)
        return String(decoding: data, as: UTF8.self)
    }

    // MARK: Writing

    /// Data to write, with server timestamps and geo points turned back into Firestore values.
    static func data(_ json: String) throws -> [String: Any] {
        guard let map = try JSONSerialization.jsonObject(with: Data(json.utf8)) as? [String: Any] else {
            throw Failure.malformed
        }
        return map.mapValues(firestoreValue)
    }

    static func firestoreValue(_ value: Any) -> Any {
        switch value {
            case let map as [String: Any]:
                if map.count == 1, map[serverTimestamp] != nil {
                    return FieldValue.serverTimestamp()
                }
                if map.count == 2, let latitude = map["latitude"] as? NSNumber, let longitude = map["longitude"] as? NSNumber {
                    return GeoPoint(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
                }
                return map.mapValues(firestoreValue)
            case let list as [Any]:
                return list.map(firestoreValue)
            default:
                return value
        }
    }
}
