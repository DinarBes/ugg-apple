//
//  OtpView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

private let otpLength = 6
private let resendDelay = 60

/// Code step of the sign-in. One hidden text field drawn as six cells: typing, paste and the
/// SMS autofill above the keyboard all land in one string.
struct OtpView: View {
    var phone: String
    @Binding var otp: String
    var isLoading: Bool
    var isResending: Bool
    var resendCount: Int
    var error: String?
    var onSubmit: () -> Void
    var onResend: () -> Void
    var onChangeNumber: () -> Void

    @FocusState private var isFocused: Bool
    @State private var secondsLeft = resendDelay

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.s) {
                Text("ПОДТВЕРЖДЕНИЕ").uggFont(.overline).foregroundStyle(UggColors.accent)
                Text("Введите код\nиз SMS").uggFont(.displayL).foregroundStyle(UggColors.content)

                HStack(spacing: 6) {
                    Text("Отправили на \(UggFormat.phone(phone))").foregroundStyle(UggColors.contentSecondary)
                    Button("Изменить", action: onChangeNumber).foregroundStyle(UggColors.accentStrong)
                }
                .uggFont(.body)

                cells.padding(.vertical, UggSpacing.s)

                if let error {
                    Text(error).uggFont(.bodySmall).foregroundStyle(UggColors.error)
                }
                resendLink
            }
            .padding(.horizontal, UggSpacing.xl)
            .padding(.vertical, UggSpacing.m)
        }
        .safeAreaInset(edge: .bottom) { actions }
        .background(UggColors.background.ignoresSafeArea())
        .onAppear { isFocused = true }
        // Restarts on every resend.
        .task(id: resendCount) {
            secondsLeft = resendDelay
            while secondsLeft > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                secondsLeft -= 1
            }
        }
    }

    private var cells: some View {
        ZStack {
            // Invisible, but focused: it owns the keyboard and the one-time-code autofill.
            TextField("", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0.02)
                .frame(width: 1, height: 1)

            HStack(spacing: 10) {
                ForEach(0..<otpLength, id: \.self) { index in
                    cell(at: index)
                    if index == otpLength / 2 - 1 {
                        Rectangle().fill(UggColors.outline).frame(width: 8, height: 2)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
        }
        .accessibilityElement()
        .accessibilityLabel("Код из SMS")
        .accessibilityValue(otp)
    }

    private func cell(at index: Int) -> some View {
        let digits = Array(otp)
        let digit = index < digits.count ? String(digits[index]) : nil
        let isActive = isFocused && index == digits.count
        let border: Color = error != nil ? UggColors.error : (isActive ? UggColors.content : UggColors.outline)
        let background: Color = error != nil
            ? UggColors.error.opacity(0.06)
            : (digit != nil ? UggColors.surfaceElevated : UggColors.surface)

        return ZStack {
            if let digit {
                Text(digit)
                    .font(.custom("CormorantGaramond-SemiBold", size: 28, relativeTo: .title))
                    .foregroundStyle(error != nil ? UggColors.error : UggColors.content)
            } else if isActive {
                BlinkingCaret()
            }
        }
        .frame(width: 46, height: 58)
        .background(background, in: RoundedRectangle(cornerRadius: UggRadius.small, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.small, style: .continuous)
                .strokeBorder(border, lineWidth: isActive || error != nil ? 1.5 : 1)
        }
    }

    @ViewBuilder
    private var resendLink: some View {
        if secondsLeft > 0 {
            Label {
                Text("Отправить код повторно через \(secondsLeft / 60):\(String(format: "%02d", secondsLeft % 60))")
                    .monospacedDigit()
            } icon: {
                UggIcon.clock.image
            }
            .uggFont(.bodySmall)
            .foregroundStyle(UggColors.contentSecondary)
        } else {
            Button("Отправить код ещё раз", action: onResend)
                .uggFont(.label)
                .foregroundStyle(isResending ? UggColors.contentSecondary : UggColors.accentStrong)
                .disabled(isResending)
        }
    }

    private var actions: some View {
        VStack(spacing: UggSpacing.s) {
            UggButton(
                isLoading ? "Проверяем…" : "Подтвердить",
                showsArrow: !isLoading,
                isLoading: isLoading,
                action: onSubmit
            )
            .disabled(otp.count != otpLength)

            Text("Код проверится сам, как только вы введёте последнюю цифру")
                .uggFont(.caption)
                .foregroundStyle(UggColors.contentSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, UggSpacing.xl)
        .padding(.vertical, UggSpacing.s)
        .background(UggColors.background)
    }
}

private struct BlinkingCaret: View {
    @State private var isVisible = true

    var body: some View {
        Rectangle()
            .fill(UggColors.content)
            .frame(width: 2, height: 24)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever()) { isVisible = false }
            }
    }
}

#Preview {
    OtpView(phone: "+79001234567", otp: .constant("123"), isLoading: false, isResending: false, resendCount: 0, error: nil, onSubmit: {}, onResend: {}, onChangeNumber: {})
}
