//
//  CartView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

/// The cart. Values and closures only; the title is the navigation bar's.
struct CartView: View {
    var cart: Cart?
    @Binding var isGiftWrapped: Bool
    var isCheckingOut: Bool
    var error: String?
    var onChooseModel: () -> Void
    var onChangeQuantity: (_ lineId: String, _ delta: Int) -> Void
    var onAddExtra: (String) -> Void
    var onSelectDelivery: (String) -> Void
    var onCheckout: () -> Void

    var body: some View {
        Group {
            if let cart {
                if cart.isEmpty {
                    EmptyCart(onChooseModel: onChooseModel)
                } else {
                    content(cart)
                }
            } else {
                ProgressView().tint(UggColors.accent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }

    private func content(_ cart: Cart) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.m) {
                Text(cart.subtitle).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)

                ForEach(cart.lines) { line in
                    LineCard(line: line) { onChangeQuantity(line.id, $0) }
                }

                if !cart.extras.isEmpty { ExtrasSection(extras: cart.extras, onAdd: onAddExtra) }

                Text("Получение")
                    .uggFont(.displayM)
                    .foregroundStyle(UggColors.content)
                    .padding(.top, UggSpacing.xs)
                ForEach(cart.deliveryOptions) { option in
                    DeliveryCard(option: option, isSelected: option.id == cart.selectedDeliveryId) {
                        onSelectDelivery(option.id)
                    }
                }

                GiftWrapRow(title: cart.giftWrapTitle, description: cart.giftWrapDescription, isOn: $isGiftWrapped)

                SummaryCard(rows: cart.summary, total: cart.total)
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .padding(.vertical, UggSpacing.s)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 10) {
                if let error {
                    Text(error)
                        .uggFont(.caption)
                        .foregroundStyle(UggColors.error)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                UggButton(
                    isCheckingOut ? "Оформляем…" : "Оформить заказ",
                    showsArrow: !isCheckingOut,
                    isLoading: isCheckingOut,
                    action: onCheckout
                )
                Text("Оплата онлайн или при получении в мастерской")
                    .uggFont(.caption)
                    .foregroundStyle(UggColors.contentSecondary)
            }
            .padding(.horizontal, UggSpacing.screenHorizontal)
            .padding(.vertical, UggSpacing.xs)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
            .background(UggColors.background)
        }
    }
}

// MARK: - Parts

private struct LineCard: View {
    let line: Cart.Line
    let onChangeQuantity: (Int) -> Void

    var body: some View {
        HStack(spacing: 14) {
            if line.isExtra {
                UggPhotoPlaceholder(radius: UggRadius.small).frame(width: 72, height: 72)
            } else {
                UggPhotoPlaceholder(radius: UggRadius.small, top: UggColors.background, bottom: UggColors.surface) {
                    UggProductImage(tint: line.color.map { Color(hex: $0) }).padding(2)
                }
                .frame(width: 88, height: 104)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(line.title).uggFont(line.isExtra ? .heading : .displayM).foregroundStyle(UggColors.content)
                Text(line.details).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                HStack {
                    Text(line.price).uggFont(.label).foregroundStyle(UggColors.content)
                    Spacer()
                    QuantityStepper(quantity: line.quantity, onChange: onChangeQuantity)
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous).strokeBorder(UggColors.outline)
        }
    }
}

private struct QuantityStepper: View {
    let quantity: Int
    let onChange: (Int) -> Void

    var body: some View {
        HStack(spacing: 10) {
            button(.minus, label: quantity == 1 ? "Удалить" : "Меньше") { onChange(-1) }
            Text("\(quantity)").uggFont(.label).foregroundStyle(UggColors.content).monospacedDigit()
            button(.plus, label: "Больше") { onChange(1) }
        }
        .padding(4)
        .background(UggColors.surface, in: Capsule())
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Количество \(quantity)")
    }

    private func button(_ icon: UggIcon, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            icon.image
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(UggColors.content)
                .frame(width: 26, height: 26)
                .background(UggColors.surfaceElevated, in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

private struct ExtrasSection: View {
    let extras: [Cart.Extra]
    let onAdd: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: UggSpacing.s) {
            Text("Добавить к заказу").uggFont(.heading).foregroundStyle(UggColors.content)

            HStack(alignment: .top, spacing: 10) {
                ForEach(extras.prefix(3)) { extra in
                    Button { onAdd(extra.id) } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            UggPhotoPlaceholder(radius: UggRadius.medium)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(alignment: .bottomTrailing) {
                                    UggIcon.plus.image
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(UggColors.content)
                                        .frame(width: 28, height: 28)
                                        .background(UggColors.surfaceElevated, in: Circle())
                                        .padding(UggSpacing.xs)
                                }
                            Text(extra.title).uggFont(.caption).foregroundStyle(UggColors.content).multilineTextAlignment(.leading)
                            Text(extra.price).uggFont(.label).foregroundStyle(UggColors.accentStrong)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .accessibilityLabel("Добавить \(extra.title), \(extra.price)")
                }
                // Keep cards the same width when only one or two offers are left.
                ForEach(0..<max(0, 3 - extras.count), id: \.self) { _ in Color.clear.frame(maxWidth: .infinity) }
            }
        }
    }
}

private struct DeliveryCard: View {
    let option: Cart.DeliveryOption
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: UggSpacing.s) {
                ZStack {
                    Circle().fill(isSelected ? UggColors.surfaceInverse : UggColors.surfaceElevated)
                    Circle().strokeBorder(isSelected ? UggColors.surfaceInverse : UggColors.outline, lineWidth: 1.5)
                    if isSelected { Circle().fill(UggColors.contentInverse).frame(width: 8, height: 8) }
                }
                .frame(width: 22, height: 22)

                VStack(alignment: .leading, spacing: 2) {
                    Text(option.title).uggFont(.label).foregroundStyle(UggColors.content)
                    Text(option.description).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)

                Text(option.price).uggFont(.label).foregroundStyle(isSelected ? UggColors.info : UggColors.content)
            }
            .padding(UggSpacing.m)
            .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous)
                    .strokeBorder(isSelected ? UggColors.content : UggColors.outline, lineWidth: isSelected ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct GiftWrapRow: View {
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: UggSpacing.s) {
                UggIcon.gift.image.font(.system(size: 20)).foregroundStyle(UggColors.accentStrong)
                VStack(alignment: .leading, spacing: 0) {
                    Text(title).uggFont(.label).foregroundStyle(UggColors.content)
                    Text(description).uggFont(.caption).foregroundStyle(UggColors.contentSecondary)
                }
            }
        }
        .tint(UggColors.surfaceInverse)
        .padding(UggSpacing.m)
        .background(UggColors.surfaceVariant.opacity(0.5), in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
    }
}

private struct SummaryCard: View {
    let rows: [Cart.SummaryRow]
    let total: String

    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows, id: \.self) { row in
                HStack {
                    Text(row.title).foregroundStyle(UggColors.contentSecondary)
                    Spacer()
                    Text(row.value).foregroundStyle(UggColors.content)
                }
                .uggFont(.bodySmall)
            }
            Divider().overlay(UggColors.outline)
            HStack {
                Text("Итого").uggFont(.heading).foregroundStyle(UggColors.content)
                Spacer()
                Text(total).uggFont(.price).foregroundStyle(UggColors.content)
            }
        }
        .padding(18)
        .background(UggColors.surfaceElevated, in: RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: UggRadius.large, style: .continuous).strokeBorder(UggColors.outline)
        }
    }
}

private struct EmptyCart: View {
    let onChooseModel: () -> Void

    var body: some View {
        VStack(spacing: UggSpacing.s) {
            UggIcon.bag.image.font(.system(size: 40, weight: .light)).foregroundStyle(UggColors.accent)
            Text("Корзина пуста").uggFont(.displayM).foregroundStyle(UggColors.content)
            Text("Выберите цвет и размер — мастер сошьёт пару за 5–7 дней.")
                .uggFont(.body)
                .foregroundStyle(UggColors.contentSecondary)
                .multilineTextAlignment(.center)
            UggButton("Выбрать пару", action: onChooseModel).fixedSize().padding(.top, UggSpacing.xs)
        }
        .padding(.horizontal, UggSpacing.screenHorizontal)
    }
}
