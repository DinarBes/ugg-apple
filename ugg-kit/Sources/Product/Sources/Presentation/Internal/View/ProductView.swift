//
//  ProductView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// The single model with its options. Values and closures only.
struct ProductView: View {
    var state: ProductState
    var onRetry: () -> Void
    var onRefresh: () async -> Void
    var onSelectShade: (String) -> Void
    var onSelectHeight: (String) -> Void
    var onSelectSize: (String) -> Void
    var onToggleDetail: (Int) -> Void
    var onAddToCart: () -> Void

    var body: some View {
        Group {
            if let product = state.product {
                content(product)
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

    private func content(_ product: Product) -> some View {
        let tint = state.selectedShade.map { Color(hex: $0.color) }

        return ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Gallery(product: product, tint: tint)

                VStack(alignment: .leading, spacing: 0) {
                    Summary(product: product)
                    Options(
                        product: product,
                        selection: state.selection,
                        selectedShadeName: state.selectedShade?.name,
                        onSelectShade: onSelectShade,
                        onSelectHeight: onSelectHeight,
                        onSelectSize: onSelectSize
                    )
                    if !product.features.isEmpty { Features(features: product.features) }
                    if !product.details.isEmpty {
                        Details(details: product.details, expanded: state.expandedDetail, onToggle: onToggleDetail)
                    }
                }
                // A readable column on an iPad.
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
        }
        // The gallery runs under the status bar, like the Android screen.
        .ignoresSafeArea(edges: .top)
        .refreshable { await onRefresh() }
        .safeAreaInset(edge: .bottom) {
            BottomBar(
                price: product.price,
                summary: state.selectionSummary,
                isComplete: state.selection.isComplete,
                onAddToCart: onAddToCart
            )
        }
    }
}

// MARK: - Gallery

private struct Gallery: View {
    let product: Product
    let tint: Color?

    @State private var page = 0

    private var pages: Int { max(product.photoCount, 1) }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                TabView(selection: $page) {
                    ForEach(0..<pages, id: \.self) { index in
                        UggPhotoPlaceholder(radius: 0, top: UggColors.background, bottom: backdrop) {
                            UggProductImage(tint: tint).padding(.horizontal, UggSpacing.xs)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 6) {
                    ForEach(0..<pages, id: \.self) { index in
                        Capsule()
                            .fill(UggColors.content.opacity(index == page ? 0.9 : 0.25))
                            .frame(width: index == page ? 22 : 6, height: 6)
                    }
                }
                .padding(.bottom, UggSpacing.l)
                .animation(.easeInOut(duration: 0.25), value: page)
            }
            .frame(height: 500)
            .overlay(alignment: .topTrailing) {
                // The system share sheet.
                ShareLink(item: "\(product.title) — \(product.price). Угги ручной работы с Байкала.") {
                    UggIcon.share.image
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(UggColors.content)
                        .frame(width: 44, height: 44)
                        .background(UggColors.surfaceElevated.opacity(0.85), in: Circle())
                }
                .accessibilityLabel("Поделиться")
                .padding(.horizontal, UggSpacing.screenHorizontal)
                .padding(.top, 56)
            }

            if product.photoCount > 1 { thumbnails }
        }
    }

    private var backdrop: Color {
        tint.map { $0.opacity(0.35) } ?? UggColors.surface
    }

    private var thumbnails: some View {
        let visible = min(product.photoCount, 4)

        return HStack(spacing: 10) {
            ForEach(0..<visible, id: \.self) { index in
                Button { withAnimation { page = index } } label: {
                    UggPhotoPlaceholder(radius: UggRadius.small, top: UggColors.background, bottom: backdrop) {
                        UggProductImage(tint: tint).padding(2)
                    }
                    .frame(width: 64, height: 64)
                    .overlay {
                        if page == index {
                            RoundedRectangle(cornerRadius: UggRadius.small, style: .continuous)
                                .strokeBorder(UggColors.content, lineWidth: 1.5)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            if product.photoCount > visible {
                Button { withAnimation { page = visible } } label: {
                    Text("+\(product.photoCount - visible)")
                        .uggFont(.label)
                        .foregroundStyle(UggColors.contentSecondary)
                        .frame(width: 64, height: 64)
                        .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.small, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, 14)
    }
}

// MARK: - Sections

private struct Summary: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(product.kicker.uppercased()).uggFont(.overline).foregroundStyle(UggColors.accent)
            Text(product.title).uggFont(.displayXL).foregroundStyle(UggColors.content)

            HStack {
                Text(product.price).uggFont(.price).foregroundStyle(UggColors.accentStrong)
                Spacer()
                HStack(spacing: 6) {
                    Circle().fill(UggColors.info).frame(width: 6, height: 6)
                    Text(product.leadTime).uggFont(.caption).foregroundStyle(UggColors.info)
                }
                .padding(.horizontal, UggSpacing.s)
                .padding(.vertical, 6)
                .background(UggColors.info.opacity(0.12), in: Capsule())
            }

            Text(product.description).uggFont(.body).foregroundStyle(UggColors.contentSecondary)

            Divider().overlay(UggColors.outline).padding(.vertical, 4)
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.top, UggSpacing.xs)
    }
}

private struct Options: View {
    let product: Product
    let selection: ProductState.Selection
    let selectedShadeName: String?
    let onSelectShade: (String) -> Void
    let onSelectHeight: (String) -> Void
    let onSelectSize: (String) -> Void

    private let sizeColumns = Array(repeating: GridItem(.flexible(), spacing: UggSpacing.xs), count: 5)

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if !product.shades.isEmpty {
                HStack(spacing: 6) {
                    Text("Цвет").foregroundStyle(UggColors.content)
                    if let selectedShadeName {
                        Text("· \(selectedShadeName)").foregroundStyle(UggColors.contentSecondary)
                    }
                }
                .uggFont(.heading)

                FlowLayout(spacing: UggSpacing.xs) {
                    ForEach(product.shades) { shade in
                        UggColorChip(shade.name, color: Color(hex: shade.color), isSelected: shade.id == selection.shadeId) {
                            onSelectShade(shade.id)
                        }
                    }
                }
            }

            if product.heights.count > 1 {
                Text("Высота голенища").uggFont(.heading).foregroundStyle(UggColors.content).padding(.top, 6)
                UggSegmentedControl(
                    product.heights.map { UggSegment($0.name, subtitle: $0.value) },
                    selectedIndex: product.heights.firstIndex { $0.id == selection.heightId }
                ) { onSelectHeight(product.heights[$0].id) }
            }

            if !product.sizes.isEmpty {
                Text("Размер").uggFont(.heading).foregroundStyle(UggColors.content).padding(.top, 6)

                LazyVGrid(columns: sizeColumns, spacing: UggSpacing.xs) {
                    ForEach(product.sizes, id: \.label) { size in
                        UggSizeCell(size.label, isSelected: size.label == selection.size, isEnabled: size.isAvailable) {
                            onSelectSize(size.label)
                        }
                    }
                }

                if let hint = product.customSizeHint {
                    Label {
                        Text(hint).uggFont(.bodySmall).foregroundStyle(UggColors.content)
                    } icon: {
                        UggIcon.ruler.image.foregroundStyle(UggColors.accentStrong)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, UggSpacing.s)
                    .background(UggColors.surfaceVariant.opacity(0.5), in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
                }
            }
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, 14)
    }
}

private struct Features: View {
    let features: [Product.Feature]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Почему они тёплые").uggFont(.displayM).foregroundStyle(UggColors.content)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(features, id: \.self) { feature in
                    VStack(alignment: .leading, spacing: 10) {
                        icon(feature.kind).image
                            .font(.system(size: 20))
                            .foregroundStyle(UggColors.accentStrong)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(feature.title).uggFont(.label).foregroundStyle(UggColors.content)
                            Text(feature.caption).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(UggSpacing.m)
                    .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
                }
            }
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, UggSpacing.s)
    }

    private func icon(_ kind: Product.Feature.Kind) -> UggIcon {
        switch kind {
            case .material: .leaf
            case .handmade: .scissors
            case .warmth: .snowflake
            case .warranty: .shieldCheck
        }
    }
}

private struct Details: View {
    let details: [Product.Detail]
    let expanded: Int?
    let onToggle: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(details.enumerated()), id: \.offset) { index, detail in
                let isExpanded = index == expanded

                Divider().overlay(UggColors.outline)
                Button { withAnimation(.easeInOut(duration: 0.2)) { onToggle(index) } } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(detail.title).uggFont(.heading).foregroundStyle(UggColors.content)
                            Spacer()
                            (isExpanded ? UggIcon.chevronUp : UggIcon.chevronDown).image
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(UggColors.content)
                        }
                        if isExpanded {
                            Text(detail.body)
                                .uggFont(.bodySmall)
                                .foregroundStyle(UggColors.contentSecondary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.vertical, 18)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isExpanded ? .isSelected : [])
            }
            Divider().overlay(UggColors.outline)
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.top, UggSpacing.s)
        .padding(.bottom, UggSpacing.xl)
    }
}

private struct BottomBar: View {
    let price: String
    let summary: String
    let isComplete: Bool
    let onAddToCart: () -> Void

    var body: some View {
        HStack(spacing: UggSpacing.m) {
            VStack(alignment: .leading, spacing: 0) {
                Text(price).uggFont(.price).foregroundStyle(UggColors.content)
                Text(summary).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
            }
            UggButton(isComplete ? "В корзину" : "Выберите размер", showsArrow: isComplete, action: onAddToCart)
                .disabled(!isComplete)
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
        .padding(.vertical, 14)
        .background {
            UggColors.surfaceElevated
                .overlay(alignment: .top) { Divider().overlay(UggColors.outline) }
                .ignoresSafeArea(edges: .bottom)
        }
    }
}
