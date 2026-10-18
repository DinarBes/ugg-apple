//
//  UggSizeCell.swift
//  ugg-kit
//

import SwiftUI

/// «Size Cell» of the design. A disabled cell is a size that cannot be ordered right now: struck
/// through and not tappable.
public struct UggSizeCell: View {
    private let label: String
    private let isSelected: Bool
    private let isEnabled: Bool
    private let action: () -> Void

    public init(_ label: String, isSelected: Bool, isEnabled: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
                .strikethrough(!isEnabled)
                .uggFont(.label)
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(background, in: RoundedRectangle(cornerRadius: UggRadius.small, style: .continuous))
                .overlay {
                    if !isSelected && isEnabled {
                        RoundedRectangle(cornerRadius: UggRadius.small, style: .continuous).strokeBorder(UggColors.outline)
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var background: Color {
        if isSelected { return UggColors.surfaceInverse }
        return isEnabled ? UggColors.surfaceElevated : UggColors.surface
    }

    private var foreground: Color {
        if isSelected { return UggColors.contentInverse }
        return isEnabled ? UggColors.content : UggColors.contentSecondary.opacity(0.45)
    }
}
