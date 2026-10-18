//
//  OnboardingView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

struct OnboardingView: View {
    var slides: [OnboardingSlide]
    @Binding var page: Int
    var isLastPage: Bool
    var error: String?
    var onRetry: () -> Void
    var onStart: () -> Void
    var onLogin: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            UggWordmark().padding(.top, UggSpacing.s)

            if let error {
                VStack(alignment: .leading, spacing: UggSpacing.m) {
                    Spacer()
                    Text(error).uggFont(.body).foregroundStyle(UggColors.contentInverse)
                    UggButton("Повторить", variant: .light, showsArrow: false, action: onRetry).fixedSize()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, UggSpacing.xl)
            } else {
                // The system pager: swipes, rubber-banding and VoiceOver paging for free.
                TabView(selection: $page) {
                    ForEach(Array(slides.enumerated()), id: \.element.id) { index, slide in
                        SlideView(slide: slide).tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }

            VStack(alignment: .leading, spacing: UggSpacing.l) {
                PageIndicator(count: slides.count, current: page)

                VStack(spacing: UggSpacing.xs) {
                    UggButton(isLastPage ? "Начать" : "Далее", variant: .light) {
                        if isLastPage {
                            onStart()
                        } else {
                            withAnimation { page += 1 }
                        }
                    }

                    Button("Войти по номеру телефона", action: onLogin)
                        .uggFont(.label)
                        .foregroundStyle(UggColors.contentInverse.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, UggSpacing.s)
                }
            }
            .padding(.horizontal, UggSpacing.xl)
            .padding(.top, 14)
            .padding(.bottom, UggSpacing.m)
        }
        // The copy keeps a readable width on an iPad; the gradient fills the whole screen.
        .frame(maxWidth: 640)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            // Placeholder for the photo «мастер шьёт угги у окна, за окном — Байкал»: light top
            // under the status bar, dark bottom under the white copy.
            LinearGradient(
                colors: [UggColors.surfaceVariant, UggColors.accentStrong, UggColors.surfaceInverse],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

private struct SlideView: View {
    let slide: OnboardingSlide

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Spacer()
            Text(slide.overline.uppercased())
                .uggFont(.overline)
                .foregroundStyle(UggColors.surfaceVariant)
            Text(slide.title)
                .uggFont(.displayXL)
                .foregroundStyle(UggColors.contentInverse)
            Text(slide.description)
                .uggFont(.body)
                .foregroundStyle(UggColors.contentInverse.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, UggSpacing.xl)
    }
}

private struct PageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(UggColors.contentInverse.opacity(index == current ? 1 : 0.4))
                    .frame(width: index == current ? 24 : 6, height: 6)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: current)
        .accessibilityHidden(true)
    }
}

#Preview {
    OnboardingView(
        slides: [
            OnboardingSlide(id: "1", overline: "Мастерская на Байкале", title: "Тепло, сшитое\nруками", description: "Одна модель, доведённая до совершенства."),
            OnboardingSlide(id: "2", overline: "Под заказ", title: "Ваша пара —\nот мерки до шва", description: "Мастер сошьёт пару за 5–7 дней."),
        ],
        page: .constant(0),
        isLastPage: false,
        error: nil,
        onRetry: {},
        onStart: {},
        onLogin: {}
    )
}
