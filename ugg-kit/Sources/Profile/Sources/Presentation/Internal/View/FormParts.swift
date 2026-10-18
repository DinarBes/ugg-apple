//
//  FormParts.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// A form screen of the profile: scrolling content, the main button pinned over the keyboard.
struct ProfileForm<Content: View, Bottom: View>: View {
    @ViewBuilder var content: () -> Content
    @ViewBuilder var bottom: () -> Bottom

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.m) {
                content()
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .padding(.vertical, UggSpacing.s)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: UggSpacing.xs) {
                bottom()
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .padding(.vertical, UggSpacing.xs)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
            .background(UggColors.background)
        }
    }
}

/// A failed load in place of the content, with «Повторить».
struct ProfileLoadError: View {
    var message: String
    var onRetry: () -> Void

    var body: some View {
        VStack(spacing: UggSpacing.m) {
            Text(message)
                .uggFont(.body)
                .foregroundStyle(UggColors.contentSecondary)
                .multilineTextAlignment(.center)
            UggButton("Повторить", variant: .secondary, showsArrow: false, action: onRetry).fixedSize()
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
    }
}

/// A failed save, under the fields.
struct ProfileSaveError: View {
    var message: String?

    var body: some View {
        if let message {
            Text(message)
                .uggFont(.bodySmall)
                .foregroundStyle(UggColors.error)
        }
    }
}
