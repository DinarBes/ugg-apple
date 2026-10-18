//
//  NameView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

struct NameView: View {
    @Binding var name: String
    var state: NameState
    var onSave: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.m) {
                Text("Так к вам будет обращаться мастер, и это имя увидит в заказе.")
                    .uggFont(.body)
                    .foregroundStyle(UggColors.contentSecondary)

                UggTextField("Как к вам обращаться", text: $name, placeholder: "Анна", error: state.error)
                    .textContentType(.givenName)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.done)
                    .onSubmit { if state.canSave { onSave() } }
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .padding(.vertical, UggSpacing.s)
        }
        .safeAreaInset(edge: .bottom) {
            UggButton(state.isSaving ? "Сохраняем…" : "Сохранить", showsArrow: false, isLoading: state.isSaving, action: onSave)
                .disabled(!state.canSave)
                .padding(.horizontal, UggSpacing.screenHorizontal)
                .padding(.vertical, UggSpacing.xs)
                .background(UggColors.background)
        }
        .background(UggColors.background.ignoresSafeArea())
    }
}
