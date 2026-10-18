//
//  InitiateView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Phone step of the sign-in. Values and closures only.
struct InitiateView: View {
    @Binding var nationalNumber: String
    var isComplete: Bool
    var isLoading: Bool
    var error: String?
    var onSubmit: () -> Void
    var onSkip: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.s) {
                Text("ВХОД").uggFont(.overline).foregroundStyle(UggColors.accent)
                Text("Ваш номер\nтелефона").uggFont(.displayL).foregroundStyle(UggColors.content)
                Text("Пришлём код в SMS. По номеру сохраним ваши заказы и сообщим, когда пара будет готова.")
                    .uggFont(.body)
                    .foregroundStyle(UggColors.contentSecondary)

                Text("Телефон")
                    .uggFont(.caption)
                    .foregroundStyle(UggColors.contentSecondary)
                    .padding(.top, UggSpacing.xs)

                phoneField

                if let error {
                    Text(error).uggFont(.bodySmall).foregroundStyle(UggColors.error)
                } else {
                    Label {
                        Text("Номер нужен только для заказов — без рассылок и звонков.")
                    } icon: {
                        UggIcon.shieldCheck.image
                    }
                    .uggFont(.caption)
                    .foregroundStyle(UggColors.contentSecondary)
                    .padding(.top, UggSpacing.xxs)
                }
            }
            .padding(.horizontal, UggSpacing.xl)
            .padding(.vertical, UggSpacing.m)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) { actions }
        .background(UggColors.background.ignoresSafeArea())
        .onAppear { isFocused = true }
    }

    private var phoneField: some View {
        HStack(spacing: UggSpacing.s) {
            Text("+7").uggFont(.heading).foregroundStyle(UggColors.content)
            Rectangle().fill(UggColors.outline).frame(width: 1, height: 24)
            TextField(
                "",
                text: $nationalNumber,
                prompt: Text("900 000-00-00").foregroundColor(UggColors.contentSecondary.opacity(0.5))
            )
            .uggFont(.heading)
            .foregroundStyle(UggColors.content)
            .keyboardType(.numberPad)
            .textContentType(.telephoneNumber)
            .focused($isFocused)
        }
        .padding(.horizontal, UggSpacing.m)
        .frame(height: 56)
        .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous)
                .strokeBorder(borderColor, lineWidth: isFocused || error != nil ? 1.5 : 1)
        }
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
    }

    private var borderColor: Color {
        if error != nil { return UggColors.error }
        return isFocused ? UggColors.content : UggColors.outline
    }

    private var actions: some View {
        VStack(spacing: UggSpacing.s) {
            UggButton(
                isLoading ? "Отправляем код…" : "Получить код",
                showsArrow: !isLoading,
                isLoading: isLoading,
                action: onSubmit
            )
            .disabled(!isComplete)

            Text("Нажимая «Получить код», вы соглашаетесь с условиями и политикой конфиденциальности")
                .uggFont(.caption)
                .foregroundStyle(UggColors.contentSecondary)
                .multilineTextAlignment(.center)

            Button("Продолжить без входа", action: onSkip)
                .uggFont(.label)
                .foregroundStyle(UggColors.accentStrong)
                .padding(.vertical, UggSpacing.xxs)
        }
        .padding(.horizontal, UggSpacing.xl)
        .padding(.vertical, UggSpacing.s)
        .background(UggColors.background)
    }
}

#Preview {
    NavigationStack {
        InitiateView(nationalNumber: .constant("900 123-45"), isComplete: false, isLoading: false, error: nil, onSubmit: {}, onSkip: {})
    }
}
