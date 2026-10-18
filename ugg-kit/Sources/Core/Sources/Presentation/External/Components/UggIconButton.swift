//
//  UggIconButton.swift
//  ugg-kit
//

import SwiftUI

/// Round 44 pt icon button of the design (header actions). `hasBadge` puts the accent dot on it —
/// the cart with something inside.
public struct UggIconButton: View {
    private let icon: UggIcon
    private let accessibilityLabel: String
    private let background: Color
    private let hasBadge: Bool
    private let action: () -> Void

    public init(
        _ icon: UggIcon,
        accessibilityLabel: String,
        background: Color = UggColors.surface,
        hasBadge: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.accessibilityLabel = accessibilityLabel
        self.background = background
        self.hasBadge = hasBadge
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            icon.image
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(UggColors.content)
                .frame(width: 44, height: 44)
                .background(background, in: Circle())
                .overlay(alignment: .topTrailing) {
                    if hasBadge {
                        Circle()
                            .fill(UggColors.accent)
                            .frame(width: 9, height: 9)
                            .overlay { Circle().strokeBorder(background, lineWidth: 2) }
                            .offset(x: -9, y: 9)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}
