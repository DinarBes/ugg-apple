//
//  HomeView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// Home tab content. Values and closures only.
struct HomeView: View {
    var state: HomeState
    var onRetry: () -> Void
    var onRefresh: () async -> Void
    var onChooseModel: () -> Void
    var onOpenStores: () -> Void
    var onOpenStory: () -> Void
    var onOpenCare: () -> Void
    var onOpenCart: () -> Void

    var body: some View {
        Group {
            if let home = state.home {
                content(home)
            } else if let error = state.error {
                ErrorView(message: error, onRetry: onRetry)
            } else {
                ProgressView().tint(UggColors.accent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }

    private func content(_ home: Home) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                header
                HeroCard(hero: home.hero, onChoose: onChooseModel)

                if !home.stats.isEmpty { StatsRow(stats: home.stats) }
                if !home.shades.isEmpty {
                    ShadesSection(shades: home.shades, onChooseModel: onChooseModel)
                }
                if !home.craftSteps.isEmpty {
                    CraftSection(steps: home.craftSteps, onOpenStory: onOpenStory)
                }
                if let quote = home.quote { QuoteCard(quote: quote) }
                if !home.stores.isEmpty {
                    StoresSection(stores: home.stores, onOpenStores: onOpenStores)
                }
                if let care = home.care { CareBanner(care: care, onOpen: onOpenCare) }
            }
            // A readable column on an iPad; edge to edge on a phone.
            .frame(maxWidth: 820)
            .frame(maxWidth: .infinity)
            .padding(.bottom, UggSpacing.xxl)
        }
        .refreshable { await onRefresh() }
    }

    private var header: some View {
        HStack {
            UggWordmark(alignment: .leading)
            Spacer()
            UggIconButton(.bag, accessibilityLabel: "Корзина", hasBadge: state.cartCount > 0, action: onOpenCart)
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, UggSpacing.xs)
    }
}

// MARK: - Sections

private struct HeroCard: View {
    let hero: Home.Hero
    let onChoose: () -> Void

    var body: some View {
        Button(action: onChoose) {
            UggPhotoPlaceholder(radius: UggRadius.extraLarge, top: UggColors.surfaceVariant, bottom: UggColors.surfaceInverse) {
                VStack(spacing: 0) {
                    UggProductImage()
                        .padding(.horizontal, UggSpacing.xl)
                        .padding(.top, UggSpacing.m)
                        .frame(maxHeight: 250)
                    Spacer(minLength: 0)
                    copy
                }
            }
            .frame(height: 480)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, UggSpacing.s)
    }

    private var copy: some View {
        VStack(alignment: .leading, spacing: UggSpacing.xs) {
            Text(hero.kicker.uppercased()).uggFont(.overline).foregroundStyle(UggColors.surfaceVariant)
            Text(hero.title).uggFont(.displayXL).foregroundStyle(UggColors.contentInverse)
            Text(hero.description).uggFont(.bodySmall).foregroundStyle(UggColors.contentInverse.opacity(0.85))

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(hero.price).uggFont(.price).foregroundStyle(UggColors.contentInverse)
                    Text(hero.leadTime).uggFont(.caption).foregroundStyle(UggColors.contentInverse.opacity(0.7))
                }
                Spacer()
                UggButton("Выбрать", variant: .light, action: onChoose).fixedSize()
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UggSpacing.l)
    }
}

private struct StatsRow: View {
    let stats: [Home.Stat]

    var body: some View {
        HStack(alignment: .top) {
            ForEach(stats, id: \.self) { stat in
                VStack(alignment: .leading, spacing: 0) {
                    Text(stat.value).uggFont(.displayL).foregroundStyle(UggColors.accentStrong)
                    Text(stat.caption).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, UggSpacing.l)
        .padding(.vertical, 18)
        .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, UggSpacing.s)
    }
}

private struct SectionHeader: View {
    let title: String
    let link: String
    let onLink: () -> Void

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(title).uggFont(.displayM).foregroundStyle(UggColors.content)
            Spacer()
            Button(link, action: onLink).uggFont(.label).foregroundStyle(UggColors.accent)
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
    }
}

private struct ShadesSection: View {
    let shades: [Home.Shade]
    let onChooseModel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: UggSpacing.m) {
            SectionHeader(title: "Оттенки овчины", link: "Все цвета", onLink: onChooseModel)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UggSpacing.s) {
                    ForEach(shades) { shade in
                        Button(action: onChooseModel) { card(shade) }.buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, UggSpacing.screenHorizontal)
            }
        }
        .padding(.top, UggSpacing.section)
        .padding(.bottom, UggSpacing.xs)
    }

    private func card(_ shade: Home.Shade) -> some View {
        let color = Color(hex: shade.color)

        return VStack(alignment: .leading, spacing: UggSpacing.xs) {
            UggPhotoPlaceholder(radius: UggRadius.medium, top: UggColors.surface, bottom: color.opacity(0.25)) {
                UggProductImage(tint: color).padding(4)
            }
            .frame(width: 150, height: 190)

            VStack(alignment: .leading, spacing: 0) {
                Text(shade.name).uggFont(.label).foregroundStyle(UggColors.content)
                Text(shade.isInStock ? "в наличии" : "под заказ")
                    .uggFont(.caption)
                    .foregroundStyle(shade.isInStock ? UggColors.info : UggColors.contentSecondary)
            }
        }
        .frame(width: 150, alignment: .leading)
    }
}

private struct CraftSection: View {
    let steps: [Home.CraftStep]
    let onOpenStory: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: UggSpacing.m) {
            VStack(alignment: .leading, spacing: 6) {
                SectionHeader(title: "Как рождается пара", link: "История", onLink: onOpenStory)
                Text("Без конвейера: от шкуры до готовой пары — руками одного мастера.")
                    .uggFont(.bodySmall)
                    .foregroundStyle(UggColors.contentSecondary)
                    .padding(.horizontal, UggSpacing.screenHorizontal)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: UggSpacing.s) {
                    ForEach(steps, id: \.self) { step in
                        VStack(alignment: .leading, spacing: 6) {
                            UggPhotoPlaceholder(radius: UggRadius.medium).frame(width: 250, height: 180)
                            Text(step.number).uggFont(.overline).foregroundStyle(UggColors.accent).padding(.top, 4)
                            Text(step.title).uggFont(.heading).foregroundStyle(UggColors.content)
                            Text(step.description).uggFont(.bodySmall).foregroundStyle(UggColors.contentSecondary)
                        }
                        .frame(width: 250, alignment: .leading)
                    }
                }
                .padding(.horizontal, UggSpacing.screenHorizontal)
            }
        }
        .padding(.top, UggSpacing.section)
        .padding(.bottom, UggSpacing.xs)
    }
}

private struct QuoteCard: View {
    let quote: Home.Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("«").uggFont(.displayXL).foregroundStyle(UggColors.accent)
            Text(quote.text).uggFont(.displayItalic).foregroundStyle(UggColors.content)

            HStack(spacing: UggSpacing.s) {
                UggPhotoPlaceholder(radius: 20).frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 0) {
                    Text(quote.author).uggFont(.label).foregroundStyle(UggColors.content)
                    Text(quote.role).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                }
            }
            .padding(.top, 14)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, UggSpacing.xl)
        .padding(.vertical, 22)
        .background(UggColors.surfaceVariant.opacity(0.55), in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.top, UggSpacing.section)
        .padding(.bottom, UggSpacing.xs)
    }
}

private struct StoresSection: View {
    let stores: [Home.StorePreview]
    let onOpenStores: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: UggSpacing.m) {
            SectionHeader(title: "Приходите примерить", link: "На карте", onLink: onOpenStores)

            HStack(alignment: .top, spacing: UggSpacing.s) {
                ForEach(stores) { store in
                    Button(action: onOpenStores) { card(store) }.buttonStyle(.plain)
                }
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
        }
        .padding(.top, UggSpacing.section)
        .padding(.bottom, UggSpacing.xs)
    }

    private func card(_ store: Home.StorePreview) -> some View {
        let statusColor = store.isOpen ? UggColors.info : UggColors.contentSecondary

        return VStack(alignment: .leading, spacing: 6) {
            UggIcon.pin.image
                .font(.system(size: 16))
                .foregroundStyle(UggColors.accentStrong)
                .frame(width: 36, height: 36)
                .background(UggColors.surface, in: Circle())
                .padding(.bottom, 4)
            Text(store.city).uggFont(.heading).foregroundStyle(UggColors.content)
            Text(store.address).uggFont(.bodySmall).foregroundStyle(UggColors.contentSecondary)
            HStack(spacing: 6) {
                Circle().fill(statusColor).frame(width: 6, height: 6)
                Text(store.hours).uggFont(.caption).foregroundStyle(statusColor)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UggSpacing.m)
        .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous).strokeBorder(UggColors.outline)
        }
    }
}

private struct CareBanner: View {
    let care: Home.CareTeaser
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            HStack(spacing: UggSpacing.m) {
                VStack(alignment: .leading, spacing: UggSpacing.xs) {
                    Text(care.kicker.uppercased()).uggFont(.overline).foregroundStyle(UggColors.accent)
                    Text(care.title).uggFont(.displayM).foregroundStyle(UggColors.contentInverse)
                    Label(care.readTime, systemImage: UggIcon.clock.rawValue)
                        .uggFont(.caption)
                        .foregroundStyle(UggColors.surfaceVariant)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                UggIcon.arrowRight.image
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(UggColors.content)
                    .frame(width: 48, height: 48)
                    .background(UggColors.background, in: Circle())
            }
            .padding(22)
            .background(UggColors.surfaceInverse, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, UggSpacing.section)
    }
}

private struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

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
