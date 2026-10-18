//
//  DI.swift
//  template-kit
//
//  Created by Archibbald on 16.04.2026.
//

import SwiftUI
import Swinject

public extension EnvironmentValues {
    @Entry var di = Container()
}

public extension View {
    @ViewBuilder
    func dependencyInjection(_ container: Container) -> some View {
        environment(\.di, container)
    }
}
