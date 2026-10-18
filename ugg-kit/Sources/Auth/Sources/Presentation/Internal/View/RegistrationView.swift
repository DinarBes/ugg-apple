//
//  RegistrationView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Name after the first sign-in. «Готово» and «Пропустить» both close it.
struct RegistrationView: View {
    @Binding var name: String
    var isSaving: Bool
    var canSubmit: Bool
    var error: String?
    var onSubmit: () -> Void
    var onSkip: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.s) {
                Text("ЗНАКОМСТВО").uggFont(.overline).foregroundStyle(UggColors.accent)
                Text("Как к вам\nобращаться?").uggFont(.displayL).foregroundStyle(UggColors.content)
                Text("Мастер увидит имя в вашем заказе — так мы не перепутаем пары и знаем, кого ждать в мастерской.")
                    .uggFont(.body)
                    .foregroundStyle(UggColors.contentSecondary)

                Text("Имя")
                    .uggFont(.caption)
                    .foregroundStyle(UggColors.contentSecondary)
                    .padding(.top, UggSpacing.xs)

                TextField("", text: $name, prompt: Text("Анна").foregroundColor(UggColors.contentSecondary.opacity(0.5)))
                    .uggFont(.heading)
                    .foregroundStyle(UggColors.content)
                    .textContentType(.givenName)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.done)
                    .onSubmit { if canSubmit { onSubmit() } }
                    .focused($isFocused)
                    .padding(.horizontal, UggSpacing.m)
                    .frame(height: 56)
                    .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous)
                            .strokeBorder(
                                error != nil ? UggColors.error : (isFocused ? UggColors.content : UggColors.outline),
                                lineWidth: isFocused || error != nil ? 1.5 : 1
                            )
                    }

                if let error {
                    Text(error).uggFont(.bodySmall).foregroundStyle(UggColors.error)
                }
            }
            .padding(.horizontal, UggSpacing.xl)
            .padding(.vertical, UggSpacing.m)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: UggSpacing.s) {
                UggButton(isSaving ? "Сохраняем…" : "Готово", showsArrow: !isSaving, isLoading: isSaving, action: onSubmit)
                    .disabled(!canSubmit)
                Button("Пропустить", action: onSkip)
                    .uggFont(.label)
                    .foregroundStyle(UggColors.accentStrong)
            }
            .padding(.horizontal, UggSpacing.xl)
            .padding(.vertical, UggSpacing.s)
            .background(UggColors.background)
        }
        .background(UggColors.background.ignoresSafeArea())
        .onAppear { isFocused = true }
    }
}

#Preview {
    RegistrationView(name: .constant(""), isSaving: false, canSubmit: false, error: nil, onSubmit: {}, onSkip: {})
}
