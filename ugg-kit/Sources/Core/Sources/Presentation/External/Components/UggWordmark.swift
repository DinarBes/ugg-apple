//
//  UggWordmark.swift
//  ugg-kit
//

import SwiftUI

/// «БАЙКАЛ / угги ручной работы» — the brand line on the splash, onboarding and home.
public struct UggWordmark: View {
    private let color: Color
    private let alignment: HorizontalAlignment

    public init(color: Color = UggColors.content, alignment: HorizontalAlignment = .center) {
        self.color = color
        self.alignment = alignment
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: 2) {
            Text("БАЙКАЛ")
                .font(.custom("CormorantGaramond-SemiBold", size: 30, relativeTo: .title))
                .tracking(30 * 0.32)
            Text("угги ручной работы")
                .uggFont(.caption)
                .opacity(0.7)
        }
        .foregroundStyle(color)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Байкал, угги ручной работы")
    }
}
