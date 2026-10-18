//
//  UggButton.swift
//  ugg-kit
//

import SwiftUI

/// Variants of the «Button» component from the design.
public enum UggButtonVariant: Sendable {
    /// Main action of a screen: dark fill.
    case primary
    /// Secondary action: outline on the background.
    case secondary
    /// On photos and dark surfaces: white fill.
    case light
}

/// The pill button of the design, 56 pt high. Disabled through the standard `.disabled(_:)`.
///
/// ```swift
/// UggButton("В корзину") { viewModel.onAddToCart() }
/// UggButton("Позвонить", variant: .secondary, showsArrow: false) { … }
/// ```
public struct UggButton: View {
    private let title: String
    private let variant: UggButtonVariant
    private let showsArrow: Bool
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        variant: UggButtonVariant = .primary,
        showsArrow: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.showsArrow = showsArrow
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView().tint(foreground)
                } else {
                    Text(title).uggFont(.button)
                    if showsArrow {
                        UggIcon.arrowRight.image.font(.system(size: 17, weight: .medium))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(UggButtonStyle(variant: variant))
        .disabled(isLoading)
    }

    private var foreground: Color {
        variant == .primary ? UggColors.contentInverse : UggColors.content
    }
}

/// The look of `UggButton`, usable on any `Button` label: `.buttonStyle(UggButtonStyle(variant: .light))`.
public struct UggButtonStyle: ButtonStyle {
    let variant: UggButtonVariant
    @Environment(\.isEnabled) private var isEnabled

    public init(variant: UggButtonVariant = .primary) {
        self.variant = variant
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground)
            .padding(.horizontal, UggSpacing.xl)
            .frame(minHeight: UggSpacing.buttonHeight)
            .background(background, in: Capsule())
            .overlay {
                if variant == .secondary {
                    Capsule().strokeBorder(UggColors.content, lineWidth: 1.2)
                }
            }
            .contentShape(Capsule())
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }

    private var background: Color {
        switch variant {
            case .primary: UggColors.surfaceInverse
            case .secondary: UggColors.background
            case .light: UggColors.surfaceElevated
        }
    }

    private var foreground: Color {
        variant == .primary ? UggColors.contentInverse : UggColors.content
    }
}
