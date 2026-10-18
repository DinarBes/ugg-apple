//
//  UggDesignSystemPreview.swift
//  ugg-kit
//
//  The whole design system on one screen — open the Canvas (⌥⌘↩) on this file to check fonts,
//  colors and components after a change.
//

import SwiftUI

struct UggDesignSystemGallery: View {
    @State private var phone = ""
    @State private var comment = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UggSpacing.section) {
                VStack(alignment: .leading, spacing: UggSpacing.xs) {
                    Text("МАСТЕРСКАЯ НА БАЙКАЛЕ").uggFont(.overline).foregroundStyle(UggColors.accent)
                    Text("Тепло, сшитое руками").uggFont(.displayXL)
                    Text("Наши точки").uggFont(.displayL)
                    Text("Оттенки овчины").uggFont(.displayM)
                    Text("«Каждую пару я шью так, как шила бы себе»").uggFont(.displayItalic)
                    Text("Мастерская и магазин").uggFont(.heading)
                    Text("Одна модель, доведённая до совершенства: натуральная овчина, ручной шов и пять природных оттенков.").uggFont(.body)
                    Text("Ежедневно 10:00–20:00").uggFont(.bodySmall).foregroundStyle(UggColors.contentSecondary)
                    Text("45 000 ₽").uggFont(.price).foregroundStyle(UggColors.accentStrong)
                }
                .foregroundStyle(UggColors.content)

                HStack(spacing: UggSpacing.xs) {
                    ForEach([UggColors.background, UggColors.surface, UggColors.surfaceVariant, UggColors.accent, UggColors.accentStrong, UggColors.surfaceInverse, UggColors.info, UggColors.error], id: \.self) { color in
                        Circle().fill(color).frame(width: 32, height: 32).overlay { Circle().strokeBorder(UggColors.outline) }
                    }
                }

                VStack(spacing: UggSpacing.s) {
                    UggButton("В корзину") { }
                    UggButton("Позвонить", variant: .secondary, showsArrow: false) { }
                    UggButton("Оформляем…", isLoading: true) { }
                    UggButton("Выберите размер") { }.disabled(true)
                }

                HStack(spacing: UggSpacing.xs) {
                    UggChip("Все · 2", isSelected: true) { }
                    UggChip("Иркутск") { }
                    UggChip("Примерка")
                    Spacer()
                    UggIconButton(.bag, accessibilityLabel: "Корзина", hasBadge: true) { }
                }

                UggTextField("Телефон", text: $phone, placeholder: "+7 900 000-00-00", hint: "Пришлём код в SMS")
                UggTextField("Комментарий", text: $comment, error: "Слишком длинно", axis: .vertical)

                UggPhotoPlaceholder(radius: UggRadius.extraLarge, top: UggColors.surfaceVariant, bottom: UggColors.surfaceInverse) {
                    UggProductImage().padding(UggSpacing.xl)
                }
                .frame(height: 280)

                HStack {
                    UggProductImage(tint: Color(hex: 0x5B3A29))
                    UggProductImage(tint: Color(hex: 0x3B3B3B))
                }
                .frame(height: 140)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                    ForEach(UggIcon.allCases, id: \.self) { icon in
                        icon.image.font(.system(size: 20)).frame(height: 32)
                    }
                }
            }
            .padding(UggSpacing.screenHorizontal)
        }
        .background(UggColors.background)
        .onAppear { UggFonts.register() }
    }
}

#Preview {
    UggDesignSystemGallery()
}
