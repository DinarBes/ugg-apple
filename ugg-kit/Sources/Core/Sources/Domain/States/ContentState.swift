//
//  ContentState.swift
//  ugg-kit
//

import Foundation

public enum ContentState<T: Sendable>: Sendable {
    case loading
    case success(T)
    case failure(String)
}
