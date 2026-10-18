//
//  ProfileView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Profile tab content. Values and closures only.
struct ProfileView: View {
    var state: ProfileState
    var onRetry: () -> Void
    var onRefresh: () async -> Void
    var onSignIn: () -> Void
    var onOpenSize: () -> Void
    var onOpenOrders: () -> Void
    var onMenuItem: (Profile.MenuItem.Kind) -> Void

    var body: some View {
        Group {
            if let profile = state.profile {
                scroll {
                    UserRow(profile: profile)
                    if let order = profile.activeOrder {
                        ActiveOrderCard(order: order)
                    }
                    HStack(spacing: 10) {
                        QuickCard(icon: .ruler, title: "Мой размер", value: profile.size ?? "не выбран", action: onOpenSize)
                        QuickCard(icon: .package, title: "Мои заказы", value: profile.ordersSummary, action: onOpenOrders)
                    }
                    if !profile.menu.isEmpty { ProfileMenu(items: profile.menu, onSelect: onMenuItem) }
                }
            } else if state.isGuest {
                scroll {
                    GuestCard(onSignIn: onSignIn)
                    ProfileMenu(
                        items: [
                            .init(kind: .care, title: "Уход за уггами"),
                            .init(kind: .contact, title: "Написать в мастерскую"),
                        ],
                        onSelect: onMenuItem
                    )
                }
            } else if let error = state.error {
                VStack(spacing: UggSpacing.m) {
                    Text(error)
                        .uggFont(.body)
                        .foregroundStyle(UggColors.contentSecondary)
                        .multilineTextAlignment(.center)
                    UggButton("Повторить", variant: .secondary, showsArrow: false, action: onRetry).fixedSize()
                }
                .padding(.horizontal, UggSpacing.screenHorizontal)
            } else {
                ProgressView().tint(UggColors.accent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }

    private func scroll<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.s) {
                content()
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .padding(.bottom, UggSpacing.l)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .refreshable { await onRefresh() }
    }
}

// MARK: - Parts

private struct Avatar: View {
    let initials: String

    var body: some View {
        ZStack {
            Circle().fill(UggColors.surfaceVariant)
            if initials.isEmpty {
                UggIcon.user.image.font(.system(size: 22)).foregroundStyle(UggColors.accentStrong)
            } else {
                Text(initials).uggFont(.heading).foregroundStyle(UggColors.accentStrong)
            }
        }
        .frame(width: 56, height: 56)
    }
}

private struct UserRow: View {
    let profile: Profile

    var body: some View {
        HStack(spacing: 14) {
            Avatar(initials: profile.initials)
            VStack(alignment: .leading, spacing: 0) {
                Text(profile.name).uggFont(.heading).foregroundStyle(UggColors.content)
                Text(profile.phone).uggFont(.bodySmall).foregroundStyle(UggColors.contentSecondary)
            }
        }
        .padding(.vertical, UggSpacing.xs)
    }
}

private struct GuestCard: View {
    let onSignIn: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: UggSpacing.s) {
            Avatar(initials: "")
            Text("Войдите по номеру телефона").uggFont(.heading).foregroundStyle(UggColors.content)
            Text("Чтобы следить за пошивом своей пары, хранить размер и адреса доставки.")
                .uggFont(.body)
                .foregroundStyle(UggColors.contentSecondary)
            UggButton("Войти", action: onSignIn)
        }
        .padding(UggSpacing.l)
        .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
    }
}

/// The order being sewn right now — the dark card.
private struct ActiveOrderCard: View {
    let order: Profile.ActiveOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(order.number.uppercased()).uggFont(.overline).foregroundStyle(UggColors.accent)
                Spacer()
                Text(order.details).uggFont(.caption).foregroundStyle(UggColors.surfaceVariant)
            }
            Text(order.title).uggFont(.displayL).foregroundStyle(UggColors.contentInverse)
            Text(order.description).uggFont(.bodySmall).foregroundStyle(UggColors.contentInverse.opacity(0.75))

            if !order.steps.isEmpty {
                progress.padding(.top, UggSpacing.xs)
            }
            if order.masterPhotoCount > 0 {
                HStack(spacing: 10) {
                    ForEach(0..<min(order.masterPhotoCount, 2), id: \.self) { _ in
                        UggPhotoPlaceholder(radius: UggRadius.small).frame(width: 52, height: 52)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Мастер прислал фото").uggFont(.label).foregroundStyle(UggColors.contentInverse)
                        Text("посмотрите, как шьётся ваша пара").uggFont(.caption).foregroundStyle(UggColors.surfaceVariant)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(UggColors.contentInverse.opacity(0.08), in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
                .padding(.top, 6)
            }
        }
        .padding(22)
        .background(UggColors.surfaceInverse, in: RoundedRectangle(cornerRadius: UggRadius.extraLarge, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private var progress: some View {
        VStack(spacing: UggSpacing.xs) {
            HStack(spacing: 0) {
                ForEach(Array(order.steps.indices), id: \.self) { index in
                    dot(isDone: index < order.currentStep, isCurrent: index == order.currentStep)
                    if index < order.steps.count - 1 {
                        Rectangle()
                            .fill(index < order.currentStep ? UggColors.accent : UggColors.contentInverse.opacity(0.25))
                            .frame(height: 2)
                    }
                }
            }
            HStack {
                ForEach(Array(order.steps.enumerated()), id: \.offset) { index, step in
                    Text(step)
                        .uggFont(.caption)
                        .foregroundStyle(index == order.currentStep ? UggColors.contentInverse : UggColors.surfaceVariant.opacity(0.7))
                    if index < order.steps.count - 1 { Spacer(minLength: 0) }
                }
            }
        }
    }

    private func dot(isDone: Bool, isCurrent: Bool) -> some View {
        ZStack {
            Circle().fill(isDone ? UggColors.accent : (isCurrent ? UggColors.contentInverse : UggColors.surfaceInverse))
            if !isDone && !isCurrent {
                Circle().strokeBorder(UggColors.contentInverse.opacity(0.4), lineWidth: 1.5)
            }
            if isDone {
                UggIcon.check.image.font(.system(size: 11, weight: .bold)).foregroundStyle(UggColors.surfaceInverse)
            } else if isCurrent {
                Circle().fill(UggColors.accent).frame(width: 10, height: 10)
            }
        }
        .frame(width: 26, height: 26)
    }
}

private struct QuickCard: View {
    let icon: UggIcon
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                icon.image.font(.system(size: 20)).foregroundStyle(UggColors.accentStrong)
                VStack(alignment: .leading, spacing: 0) {
                    Text(title).uggFont(.label).foregroundStyle(UggColors.content)
                    Text(value).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(UggSpacing.m)
            .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct ProfileMenu: View {
    let items: [Profile.MenuItem]
    let onSelect: (Profile.MenuItem.Kind) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if index > 0 { Divider().overlay(UggColors.outline) }
                row(item)
            }
        }
        .padding(6)
        .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous).strokeBorder(UggColors.outline)
        }
    }

    private func row(_ item: Profile.MenuItem) -> some View {
        let isLogout = item.kind == .logout

        return Button { onSelect(item.kind) } label: {
            HStack(spacing: 14) {
                icon(item.kind).image
                    .font(.system(size: 15))
                    .foregroundStyle(isLogout ? UggColors.contentSecondary : UggColors.accentStrong)
                    .frame(width: 36, height: 36)
                    .background(UggColors.surface, in: Circle())
                Text(item.title)
                    .uggFont(.label)
                    .foregroundStyle(isLogout ? UggColors.contentSecondary : UggColors.content)
                Spacer()
                UggIcon.chevronRight.image.font(.system(size: 13, weight: .semibold)).foregroundStyle(UggColors.contentSecondary)
            }
            .padding(.horizontal, UggSpacing.s)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func icon(_ kind: Profile.MenuItem.Kind) -> UggIcon {
        switch kind {
            case .addresses: .pin
            case .care: .leaf
            case .contact: .message
            case .logout: .logout
        }
    }
}
