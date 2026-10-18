//
//  CareView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

struct CareView: View {
    var state: CareState
    var onRetry: () -> Void
    var onContact: () -> Void

    var body: some View {
        Group {
            if let care = state.care {
                content(care)
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

    private func content(_ care: Care) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: UggSpacing.s) {
                    Text(care.kicker.uppercased()).uggFont(.overline).foregroundStyle(UggColors.accent)
                    Text(care.title).uggFont(.displayXL).foregroundStyle(UggColors.content)
                    if !care.readTime.isEmpty {
                        Label {
                            Text(care.readTime).uggFont(.caption)
                        } icon: {
                            UggIcon.clock.image.font(.system(size: 13))
                        }
                        .foregroundStyle(UggColors.contentSecondary)
                    }
                    Text(care.intro).uggFont(.body).foregroundStyle(UggColors.contentSecondary)
                }
                .padding(.vertical, UggSpacing.s)

                VStack(spacing: UggSpacing.s) {
                    ForEach(Array(care.tips.enumerated()), id: \.offset) { _, tip in
                        TipCard(tip: tip)
                    }
                }
                .padding(.vertical, UggSpacing.xs)

                if !care.donts.isEmpty {
                    DontsCard(title: care.dontsTitle, items: care.donts)
                        .padding(.top, UggSpacing.m)
                }

                if let contact = care.contact {
                    ContactCard(contact: contact, action: onContact)
                        .padding(.top, UggSpacing.l)
                }
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .padding(.bottom, UggSpacing.xl)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct TipCard: View {
    var tip: Care.Tip

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            tip.kind.icon.image
                .font(.system(size: 18))
                .foregroundStyle(UggColors.accentStrong)
                .frame(width: 40, height: 40)
                .background(UggColors.surface, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title).uggFont(.heading).foregroundStyle(UggColors.content)
                Text(tip.body).uggFont(.bodySmall).foregroundStyle(UggColors.contentSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(UggSpacing.m)
        .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous).strokeBorder(UggColors.outline)
        }
    }
}

private struct DontsCard: View {
    var title: String
    var items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: UggSpacing.s) {
            Text(title).uggFont(.heading).foregroundStyle(UggColors.content)
            ForEach(items, id: \.self) { item in
                HStack(spacing: 10) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(UggColors.error)
                        .frame(width: 22, height: 22)
                        .background(UggColors.error.opacity(0.12), in: Circle())
                    Text(item).uggFont(.body).foregroundStyle(UggColors.content)
                }
            }
        }
        .padding(UggSpacing.l)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
    }
}

private struct ContactCard: View {
    var contact: Care.Contact
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            UggIcon.message.image
                .font(.system(size: 22))
                .foregroundStyle(UggColors.contentInverse)
            Text(contact.title).uggFont(.displayM).foregroundStyle(UggColors.contentInverse)
            Text(contact.body).uggFont(.bodySmall).foregroundStyle(UggColors.contentInverse.opacity(0.8))
            UggButton(contact.button, variant: .light, action: action)
                .padding(.top, 6)
        }
        .padding(UggSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(UggColors.surfaceInverse, in: RoundedRectangle(cornerRadius: UggRadius.extraLarge, style: .continuous))
    }
}

private extension Care.Tip.Kind {
    var icon: UggIcon {
        switch self {
            case .snow: .snowflake
            case .drying: .clock
            case .salt: .leaf
            case .cleaning: .scissors
            case .protection: .shieldCheck
            case .storage: .package
            case .other: .leaf
        }
    }
}
