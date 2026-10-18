//
//  UggColorChip.swift
//  ugg-kit
//

import SwiftUI

/// «Color Chip» of the design: swatch and name; the selected one gets a dark outline.
public struct UggColorChip: View {
    private let name: String
    private let color: Color
    private let isSelected: Bool
    private let action: () -> Void

    public init(_ name: String, color: Color, isSelected: Bool, action: @escaping () -> Void) {
        self.name = name
        self.color = color
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: UggSpacing.xs) {
                Circle()
                    .fill(color)
                    .frame(width: 18, height: 18)
                    .overlay { Circle().strokeBorder(UggColors.content.opacity(0.12)) }
                Text(name).uggFont(.label).foregroundStyle(UggColors.content)
            }
            .padding(.leading, 10)
            .padding(.trailing, 14)
            .padding(.vertical, UggSpacing.xs)
            .background(isSelected ? UggColors.surfaceElevated : UggColors.surface, in: Capsule())
            .overlay {
                if isSelected { Capsule().strokeBorder(UggColors.content, lineWidth: 1.2) }
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
