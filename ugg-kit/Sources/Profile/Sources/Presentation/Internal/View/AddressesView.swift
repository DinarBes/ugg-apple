//
//  AddressesView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

struct AddressesView: View {
    var state: AddressesState
    var onRetry: () -> Void
    var onRefresh: () async -> Void
    var onOpen: (String) -> Void
    var onAdd: () -> Void

    var body: some View {
        Group {
            if state.isLoading && state.addresses.isEmpty {
                ProgressView().tint(UggColors.accent)
            } else if let error = state.error, state.addresses.isEmpty {
                ProfileLoadError(message: error, onRetry: onRetry)
            } else {
                ProfileForm {
                    if state.addresses.isEmpty {
                        EmptyAddresses()
                    } else {
                        ForEach(state.addresses) { address in
                            AddressCard(address: address) { onOpen(address.id) }
                        }
                    }
                } bottom: {
                    UggButton("Добавить адрес", showsArrow: false, action: onAdd)
                }
                .refreshable { await onRefresh() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }
}

private struct AddressCard: View {
    var address: Address
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: UggSpacing.s) {
                UggIcon.pin.image
                    .font(.system(size: 18))
                    .foregroundStyle(UggColors.accentStrong)

                VStack(alignment: .leading, spacing: 2) {
                    if address.isDefault {
                        Text("ОСНОВНОЙ").uggFont(.overline).foregroundStyle(UggColors.accent)
                    }
                    Text(address.summary)
                        .uggFont(.label)
                        .foregroundStyle(UggColors.content)
                    if !address.comment.isEmpty {
                        Text(address.comment)
                            .uggFont(.caption)
                            .foregroundStyle(UggColors.contentSecondary)
                    }
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

                UggIcon.chevronRight.image
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(UggColors.contentSecondary)
            }
            .padding(UggSpacing.m)
            .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous)
                    .strokeBorder(address.isDefault ? UggColors.accent : UggColors.outline, lineWidth: address.isDefault ? 1.5 : 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct EmptyAddresses: View {
    var body: some View {
        VStack(spacing: UggSpacing.s) {
            UggIcon.pin.image
                .font(.system(size: 30))
                .foregroundStyle(UggColors.accentStrong)
            Text("Пока нет адресов")
                .uggFont(.heading)
                .foregroundStyle(UggColors.content)
            Text("Добавьте адрес — при заказе с доставкой он подставится сам.")
                .uggFont(.body)
                .foregroundStyle(UggColors.contentSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, UggSpacing.xl)
    }
}
