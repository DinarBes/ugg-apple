//
//  AddressFormView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

struct AddressFormView: View {
    @Binding var city: String
    @Binding var street: String
    @Binding var flat: String
    @Binding var comment: String
    @Binding var isDefault: Bool
    var state: AddressFormState
    var onSave: () -> Void
    var onDelete: () -> Void

    var body: some View {
        Group {
            if state.isLoading {
                ProgressView().tint(UggColors.accent)
            } else {
                form
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }

    private var form: some View {
        ProfileForm {
            UggTextField("Город", text: $city, placeholder: "Иркутск", error: state.cityError)
                .textContentType(.addressCity)
                .textInputAutocapitalization(.words)
            UggTextField("Улица и дом", text: $street, placeholder: "ул. Ленина, 12", error: state.streetError)
                .textContentType(.streetAddressLine1)
                .textInputAutocapitalization(.sentences)
            UggTextField("Квартира или офис", text: $flat, placeholder: "Необязательно")
                .textContentType(.streetAddressLine2)
            UggTextField("Комментарий для курьера", text: $comment, placeholder: "Подъезд, этаж, домофон", axis: .vertical)
                .textInputAutocapitalization(.sentences)

            Toggle(isOn: $isDefault) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Основной адрес")
                        .uggFont(.label)
                        .foregroundStyle(UggColors.content)
                    Text("Подставим его при заказе с доставкой")
                        .uggFont(.caption)
                        .foregroundStyle(UggColors.contentSecondary)
                }
            }
            .tint(UggColors.accent)
            .padding(.vertical, UggSpacing.xxs)

            ProfileSaveError(message: state.error)
        } bottom: {
            UggButton(state.isSaving ? "Сохраняем…" : "Сохранить", showsArrow: false, isLoading: state.isSaving, action: onSave)
            if state.isExisting {
                Button("Удалить адрес", role: .destructive, action: onDelete)
                    .uggFont(.label)
                    .foregroundStyle(UggColors.error)
                    .padding(.vertical, UggSpacing.xxs)
                    .disabled(state.isSaving)
            }
        }
    }
}
