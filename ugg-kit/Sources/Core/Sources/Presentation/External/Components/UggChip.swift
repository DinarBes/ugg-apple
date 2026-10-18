//
//  UggChip.swift
//  ugg-kit
//

import SwiftUI

/// Pill chip: city filters, services of a store, quick choices. Selected is dark.
public struct UggChip: View {
    private let title: String
    private let isSelected: Bool
    private let action: (() -> Void)?

    public init(_ title: String, isSelected: Bool = false, action: (() -> Void)? = nil) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        if let action {
            Button(action: action) { label }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
        } else {
            label
        }
    }

    private var label: some View {
        Text(title)
            .uggFont(.caption)
            .foregroundStyle(isSelected ? UggColors.contentInverse : UggColors.content)
            .padding(.horizontal, UggSpacing.s)
            .padding(.vertical, 6)
            .background(isSelected ? UggColors.surfaceInverse : UggColors.surface, in: Capsule())
    }
}
