//
//  UggTextField.swift
//  ugg-kit
//

import SwiftUI

/// A labelled text field in the app's style: caption above, rounded box, the error under it in
/// place of `hint`. Multi-line with `axis: .vertical` (comments).
public struct UggTextField: View {
    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let hint: String?
    private let error: String?
    private let axis: Axis

    @FocusState private var isFocused: Bool

    public init(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        hint: String? = nil,
        error: String? = nil,
        axis: Axis = .horizontal
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.hint = hint
        self.error = error
        self.axis = axis
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .uggFont(.caption)
                .foregroundStyle(UggColors.contentSecondary)

            TextField(
                "",
                text: $text,
                // foregroundColor, not foregroundStyle: the Text-returning foregroundStyle needs iOS 17.
                prompt: Text(placeholder).foregroundColor(UggColors.contentSecondary.opacity(0.5)),
                axis: axis
            )
            .lineLimit(axis == .vertical ? 3...6 : 1...1)
            .uggFont(.body)
            .foregroundStyle(UggColors.content)
            .tint(UggColors.content)
            .focused($isFocused)
            .padding(.horizontal, UggSpacing.m)
            .padding(.vertical, 14)
            .frame(minHeight: 52, alignment: axis == .vertical ? .topLeading : .leading)
            .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: isFocused || error != nil ? 1.5 : 1)
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }

            if let error {
                Text(error).uggFont(.caption).foregroundStyle(UggColors.error)
            } else if let hint {
                Text(hint).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var borderColor: Color {
        if error != nil { return UggColors.error }
        return isFocused ? UggColors.content : UggColors.outline
    }
}
