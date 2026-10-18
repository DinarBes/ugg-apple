//
//  SizeView.swift
//  ugg-kit
//

import SwiftUI

import UggKitCore

private let sizesPerRow = 5

struct SizeView: View {
    @Binding var footLength: String
    var state: SizeState
    var onRetry: () -> Void
    var onSelectSize: (String) -> Void
    var onSelectHeight: (String) -> Void
    var onSave: () -> Void

    var body: some View {
        Group {
            if state.isLoading {
                ProgressView().tint(UggColors.accent)
            } else if let error = state.error, state.sizes.isEmpty {
                // Only a failed load replaces the form; a failed save shows under it.
                ProfileLoadError(message: error, onRetry: onRetry)
            } else {
                form
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(UggColors.background.ignoresSafeArea())
    }

    private var form: some View {
        ProfileForm {
            Text("Сохраним размер — в следующий раз он будет выбран сам, а мастер учтёт его при пошиве.")
                .uggFont(.body)
                .foregroundStyle(UggColors.contentSecondary)

            heading("Размер")
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: UggSpacing.xs), count: sizesPerRow),
                spacing: UggSpacing.xs
            ) {
                ForEach(state.sizes, id: \.self) { size in
                    UggSizeCell(size, isSelected: size == state.size, isEnabled: true) { onSelectSize(size) }
                }
            }

            if !state.heights.isEmpty {
                heading("Высота голенища")
                UggSegmentedControl(
                    state.heights.map { UggSegment($0.name, subtitle: $0.value) },
                    selectedIndex: state.heights.firstIndex { $0.id == state.heightId },
                    onSelect: { onSelectHeight(state.heights[$0].id) }
                )
            }

            heading("Длина стопы")
            UggTextField("В сантиметрах, необязательно", text: $footLength, placeholder: "24,5", error: state.footLengthError)
                .keyboardType(.decimalPad)
            MeasureTip()

            ProfileSaveError(message: state.sizes.isEmpty ? nil : state.error)
        } bottom: {
            UggButton(state.isSaving ? "Сохраняем…" : "Сохранить", showsArrow: false, isLoading: state.isSaving, action: onSave)
                .disabled(!state.canSave)
        }
    }

    private func heading(_ title: String) -> some View {
        Text(title)
            .uggFont(.heading)
            .foregroundStyle(UggColors.content)
            .padding(.top, UggSpacing.xxs)
    }
}

private struct MeasureTip: View {
    var body: some View {
        HStack(alignment: .top, spacing: UggSpacing.s) {
            UggIcon.ruler.image
                .font(.system(size: 18))
                .foregroundStyle(UggColors.accentStrong)
            Text("Как измерить: встаньте на лист бумаги у стены, отметьте самый длинный палец и измерьте расстояние от стены до отметки. Если размера нет в сетке — сошьём по этой мерке.")
                .uggFont(.bodySmall)
                .foregroundStyle(UggColors.contentSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(UggSpacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(UggColors.surface, in: RoundedRectangle(cornerRadius: UggRadius.medium, style: .continuous))
    }
}
