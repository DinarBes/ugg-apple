//
//  StoresView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// «Наши точки»: the map, the city filter and a card per store. Values and closures only.
struct StoresView: View {
    var state: StoresState
    var onRetry: () -> Void
    var onRefresh: () async -> Void
    var onSelectCity: (String?) -> Void
    var onSelectStore: (String?) -> Void
    var onRoute: (Store) -> Void
    var onCall: (Store) -> Void

    var body: some View {
        Group {
            if state.totalCount > 0 {
                content
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

    private var content: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: UggSpacing.s) {
                    Text("Примерьте угги вживую и подберите размер вместе с мастером.")
                        .uggFont(.bodySmall)
                        .foregroundStyle(UggColors.contentSecondary)

                    StoresMap(stores: state.stores, selectedStoreId: state.selectedStoreId) { id in
                        onSelectStore(id)
                        // Bring the tapped store's card into view under the map.
                        withAnimation { proxy.scrollTo(id, anchor: .top) }
                    }
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))

                    if state.cities.count > 1 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: UggSpacing.xs) {
                                UggChip("Все · \(state.totalCount)", isSelected: state.city == nil) { onSelectCity(nil) }
                                ForEach(state.cities, id: \.self) { city in
                                    UggChip(city, isSelected: state.city == city) { onSelectCity(city) }
                                }
                            }
                        }
                    }

                    ForEach(state.stores) { store in
                        StoreCard(
                            store: store,
                            isSelected: store.id == state.selectedStoreId,
                            onSelect: { onSelectStore(store.id) },
                            onRoute: { onRoute(store) },
                            onCall: { onCall(store) }
                        )
                        .id(store.id)
                    }
                }
                .padding(.horizontal, UggSpacing.screenHorizontal)
                .padding(.bottom, UggSpacing.l)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .refreshable { await onRefresh() }
        }
    }
}

private struct StoreCard: View {
    let store: Store
    let isSelected: Bool
    let onSelect: () -> Void
    let onRoute: () -> Void
    let onCall: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            UggPhotoPlaceholder(radius: 0).frame(height: 150)

            VStack(alignment: .leading, spacing: UggSpacing.xs) {
                HStack {
                    Text(store.city.uppercased()).uggFont(.overline).foregroundStyle(UggColors.accent)
                    Spacer()
                    Text(store.status)
                        .uggFont(.caption)
                        .foregroundStyle(store.isOpen ? UggColors.info : UggColors.contentSecondary)
                        .padding(.horizontal, UggSpacing.s)
                        .padding(.vertical, 6)
                        .background(store.isOpen ? UggColors.info.opacity(0.14) : UggColors.surface, in: Capsule())
                }

                Text(store.name).uggFont(.displayM).foregroundStyle(UggColors.content)
                info(.pin, store.address)
                info(.clock, store.hours)

                if !store.services.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(store.services, id: \.self) { UggChip($0) }
                    }
                    .padding(.top, 4)
                }

                HStack(spacing: 10) {
                    UggButton("Маршрут", showsArrow: false, action: onRoute)
                    UggButton("Позвонить", variant: .secondary, showsArrow: false, action: onCall)
                        .disabled(store.phoneUri.isEmpty)
                }
                .padding(.top, UggSpacing.xs)
            }
            .padding(18)
        }
        .background(UggColors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous)
                .strokeBorder(isSelected ? UggColors.content : UggColors.outline, lineWidth: isSelected ? 1.5 : 1)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func info(_ icon: UggIcon, _ text: String) -> some View {
        Label {
            Text(text)
        } icon: {
            icon.image.font(.system(size: 13))
        }
        .uggFont(.bodySmall)
        .foregroundStyle(UggColors.contentSecondary)
    }
}
