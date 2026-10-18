//
//  AppTab.swift
//  template-kit
//

import Foundation

enum AppTab: Identifiable, Hashable, Sendable {
    var id: Self { self }

    case home
    case profile
}
